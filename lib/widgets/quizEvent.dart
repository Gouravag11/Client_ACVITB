import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:android_club_app/models/user.dart';
import 'package:android_club_app/auth/user_data_manager.dart';
import 'package:android_club_app/widgets/CustomLeaderboard.dart';

import 'app_bar.dart';

class TimerService {
  final DatabaseReference _databaseReference;

  TimerService(this._databaseReference);

  Stream<int> getQuestionRemainingTime() {
    return _databaseReference.child('qtimer').onValue.map((event) {
      return event.snapshot.value as int;
    });
  }

  Stream<int> getOptionRemainingTime() {
    return _databaseReference.child('otimer').onValue.map((event) {
      return event.snapshot.value as int;
    });
  }
}

class QuizEventPage extends StatefulWidget {
  final String quizId;
  const QuizEventPage({required this.quizId, Key? key}) : super(key: key);

  @override
  _QuizEventPageState createState() => _QuizEventPageState();
}

class _QuizEventPageState extends State<QuizEventPage> {
  AppUser? _user;
  final DatabaseReference _quizRef = FirebaseDatabase.instance.ref('qwiz');
  Map<String, dynamic>? _quizData;
  List<Map<String, dynamic>> _questions = [];
  String? _activeQuestion;
  Map<String, dynamic>? _participants;
  int _readyParticipants = 0;
  bool _isLoading = true;
  String? _errorMessage;
  int _startTime = 0; // To track the time when question is displayed
  String userPID = '';
  bool _showOptions = false;
  bool _showLeaderboards = false;
  bool answered = false;
  String timerText = 'Starting in:';
  int? _selectedOptionIndex; // Track selected option
  bool _showResult = false;


  late Timer _questionTimer;
  late Timer _optionTimer;
  int _remainingQuestionTime = 5; // Initial 5 seconds for the question
  int _remainingOptionTime = 30;  // Replace with actual time from Firebase for options
  late TimerService _timerService;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(_quizRef.child(widget.quizId));
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserDataManager.getUserData();
    setState(() {
      _user = user;
      userPID = _user!.id;
    });
    addActiveUser(_user!.id);
    _listenForActiveQuestion();
    _listenForLeaderboards();
  }

  Future<void> addActiveUser(String userId) async {
    await _quizRef.child('${widget.quizId}/participants/$userId').set({
      'name': _user!.name,
      'regno': _user!.regNo,
      'score': 0,
    });
    _fetchQuizData();
    _quizRef.child('${widget.quizId}/participants/$userId').onDisconnect().remove();
  }

  Future<void> _fetchQuizData() async {
    try {
      final snapshot = await _quizRef.child(widget.quizId).once();
      if (snapshot.snapshot.value != null) {
        setState(() {
          _quizData = Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);
          _questions = (_quizData!['questions'] as List).map((question) {
            return Map<String, dynamic>.from(question as Map);
          }).toList();
          _readyParticipants = (_quizData!['participants'] as Map).length;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Quiz not found.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching quiz data: $e";
        _isLoading = false;
      });
    }
  }

  void _listenForActiveQuestion() {
    _quizRef.child('${widget.quizId}/activeQ').onValue.listen((event) {
      final activeQ = event.snapshot.value as String?;
      setState(() {
        _activeQuestion = activeQ;
        _showResult = false;
      });
      if (activeQ != null && activeQ != '-1' && activeQ != '-2') {
        setState(() {
          _showOptions = false;
        });
        _startTime = DateTime.now().millisecondsSinceEpoch;
        _timerService.getQuestionRemainingTime().listen((remainingTime) {
          setState(() {
            _remainingQuestionTime = remainingTime;
            _showResult = false;
            if (_remainingQuestionTime == 0) {
              answered = false;
              _selectedOptionIndex = null;
              _showOptions = true;
            }
          });
        });

        _timerService.getOptionRemainingTime().listen((remainingTime) {
          setState(() {
            _remainingOptionTime = remainingTime;
            _showResult = false;
          if (_remainingOptionTime == 0) {
            _showOptions = false;
            _showResult = true;
          }
          });
        });

      }

    });
  }


  void _listenForLeaderboards() {
    _quizRef.child('${widget.quizId}/showLeaderboards').onValue.listen((event) {
      final leadPage = event.snapshot.value as bool?;
      setState(() {
        _showLeaderboards = leadPage!;
      });
      if(_showLeaderboards){
        _quizRef.child('${widget.quizId}/participants').onValue.listen((event) {
          if (event.snapshot.value != null) {
            setState(() {
              _participants = (event.snapshot.value as Map).map((key, value) {
                return MapEntry(key, Map<String, dynamic>.from(value as Map));
              }).cast<String, Map<String, dynamic>>();
            });
          } else {
            setState(() {
              _participants = null;
            });
          }
        });
      }
    });
  }

  void _submitAnswer(int selectedIndex) {
    if (_activeQuestion != null && _activeQuestion != '-1' && _activeQuestion != '-2') {
      setState(() {
        // _showOptions = false;
        _selectedOptionIndex = selectedIndex;
        answered = true;
      });
      final currentQuestion = _questions[int.parse(_activeQuestion!)];
      final isCorrect = currentQuestion['options'][selectedIndex]['isCorrect'] as bool;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeTaken = (currentTime - _startTime) / 1000;

      final score = _calculateScore(isCorrect, timeTaken);
      print("Score: " + score.toString());
      _updateUserScore(score);
    }
  }

  int _calculateScore(bool isCorrect, double timeTaken) {
    if (isCorrect) {
      int baseScore = 1000; // Base score for correct answer  // Time bonus (up to 1000 points)
      double timeBonus = max(0, 2000 - timeTaken * 80);
      return (baseScore + timeBonus).toInt();
    } else {
      return 0; // No score for incorrect answer
    }
  }

  Future<void> _updateUserScore(int score) async {
    final snapshot = await _quizRef.child('${widget.quizId}/participants/$userPID').once();
    final currentScore = ((snapshot.snapshot.value as Map?)?['score'] ?? 0) as int;
    final newScore = currentScore + score;
    await _quizRef.child('${widget.quizId}/participants/$userPID/score').set(newScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroAppBar(
        pageTitle: '${_quizData?['title'] ?? ''}',
        clickableIcons: false,
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : _showLeaderboards
            ?_buildLeaderboardsPage()
            :Column(
        children: [
          Expanded(
            child: _activeQuestion == '-1'
                ? const Center(
              child: Text(
                "Waiting for quiz to start...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
                : _activeQuestion == '-2'
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Quiz Ended", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Exit", style: GoogleFonts.poppins(fontSize: 24),),
                  ),
                ],
              ),
            )
                : Column(
              children: [
                _remainingQuestionTime != 0
                    ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Starting in:',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          "$_remainingQuestionTime",
                          style: GoogleFonts.poppins(fontSize: 24),
                        ),
                      ],
                    )
                )
                    : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Time Remaining',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          "$_remainingOptionTime",
                          style: GoogleFonts.poppins(fontSize: 24),
                        ),
                      ],
                    )
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(),
                ),

                Expanded(
                  child: _showResult
                    ? Center(
                      child: SingleChildScrollView(
                        child: _buildResultView(),
                      ),
                    )
                  : _buildQuestionView(),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_activeQuestion == null || _activeQuestion == '-1')
        const Center(
          child: Text(
            "Waiting for quiz to start...",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
        else if (_activeQuestion == '-2')
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Quiz Ended", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Exit"),
                ),
              ],
            ),
          )
        else if (_activeQuestion != null)
            ..._buildQuestionWithOptions(),
      ],
    );
  }

  List<Widget> _buildQuestionWithOptions() {
    if (_activeQuestion == null) {
      return [];
    }
    final currentQuestion = _questions[int.parse(_activeQuestion!)];
    return [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            currentQuestion['question'],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 45),
        child: Divider(),
      ),

      if (_showOptions)
        ...List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              color: _selectedOptionIndex == index ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey // For dark mode
                    : Colors.lime
                  : Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF1F1F1F) // For dark mode
                    : Color(0xFFB0E4B3), // Change color based on selection
              child: ListTile(
                title: Text(_questions[int.parse(_activeQuestion!)]['options'][index]['text']),
                onTap: () {
                  if(!answered){
                    _submitAnswer(index);
                  }
                },
              ),
            ),
          );
        }),

    ];
  }

  Widget _buildLeaderboardsPage(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Leaderboards",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 45),
            child: Divider(),
          ),
          const SizedBox(height: 5,),
          const SizedBox(height: 16),
          Expanded(
            child: HorizontalBarChart(participants: _fetchParticipants()),
          ),
        ],
      ),
    );
  }

  List<Participant> _fetchParticipants() {
    if (_participants == null) return [];

    List<MapEntry<String, dynamic>> sortedParticipants = _participants!.entries.toList();
    sortedParticipants.sort((a, b) => (b.value['score'] as int).compareTo(a.value['score'] as int));

    return sortedParticipants.take(10).map((entry) {
      final participantData = entry.value;
      return Participant(participantData['name'], participantData['score']);
    }).toList();
  }


  Widget _buildResultView() {
    final currentQuestion = _questions[int.parse(_activeQuestion!)];

    if (_selectedOptionIndex == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15,),
          Text(
            'Time\'s up!',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15,),
          Text(
            'You did not answer this question.',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ],
      );
    } else {
      final isCorrect = currentQuestion['options'][_selectedOptionIndex]['isCorrect'] as bool;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              isCorrect ? 'Correct!' : 'Incorrect !!!',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              if(isCorrect)
                Text(
                  'You answered correctly!',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              if(!isCorrect)
                Text('The correct answer is:',style: GoogleFonts.poppins(fontSize: 16)),
              Text(
                  '${currentQuestion['options'][currentQuestion['options'].indexWhere((option) => option['isCorrect'] as bool)]['text']}',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)
              )
            ],)
          ),

        ],
      );
    }
  }

  @override
  void dispose() {
    _quizRef.child('${widget.quizId}/participants/$userPID').remove();
    super.dispose();
  }
}