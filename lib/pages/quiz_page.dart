// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:android_club_app/widgets/animation_custom1.dart';
import 'package:android_club_app/widgets/app_bar.dart';
// import 'package:android_club_app/widgets/quiz_creator.dart';
import 'package:android_club_app/widgets/quizEvent.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final DatabaseReference _quizRef = FirebaseDatabase.instance.ref('qwiz');
  bool _isLoading = true;
  List<Map<String, dynamic>> _activeQuizzes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchActiveQuizzes();
  }

  Future<void> _fetchActiveQuizzes() async {
    try {
      final snapshot = await _quizRef.once();
      if (snapshot.snapshot.value != null) {
        // print(snapshot.snapshot.value as Map<dynamic, dynamic>);
        final quizzes = snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _activeQuizzes = quizzes.entries.map((entry) {
            final quizData = entry.value as Map<dynamic, dynamic>;
            return {
              'quizId': entry.key,
              'title': quizData['title'],
              'description': quizData['description'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "No quizzes found.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching quizzes: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroAppBar(
        pageTitle: 'Qwizess',
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : Column(
        children: [
          SizedBox(height: 10,),
          Expanded(child: _buildQuizList()), // Show available quizzes in cards
          // _buildCreateQuizButton(context),  // Button to create new quiz
        ],
      ),
    );
  }

  Widget _buildQuizList() {
    return ListView.builder(
      itemCount: _activeQuizzes.length,
      itemBuilder: (context, index) {
        final quiz = _activeQuizzes[index];
        return Card(
          margin: EdgeInsets.all(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF121212) // For dark mode
              : Color(0xFFCAE8C3),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to take full width
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      quiz['title'],
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      quiz['description'],
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the quiz details page or handle quiz entry
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizEventPage(quizId: quiz['quizId']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface
                  ),
                  child: Text("Enter Quiz"),
                ),
              ],
            ),
          ),
        );

      },
    );
  }
}
