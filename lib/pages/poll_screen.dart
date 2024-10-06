import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PollScreen extends StatefulWidget {
  final String roomCode;
  final String name;

  const PollScreen({super.key, required this.roomCode, required this.name});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  // Reference to the "leaderboard" node in Firebase Realtime Database
  late DatabaseReference leaderboardRef;
  late DatabaseReference votersRef;

  @override
  void initState() {
    super.initState();
    leaderboardRef =
        FirebaseDatabase.instance.ref('polls/${widget.roomCode}/leaderboard');
    votersRef =
        FirebaseDatabase.instance.ref('polls/${widget.roomCode}/voters');
  }

  void confirmVote(String teamKey, String teamName, int currentVotes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Your Vote', style: GoogleFonts.poppins(),),
          content: IntrinsicHeight(
            child: Column(
              children: [
                Text(
                  "You sure you wanna vote for: ",
                  style: GoogleFonts.poppins(

                  ),
                ),
                Text(
                  "$teamName?",
                  style: GoogleFonts.poppins(
                    color: Colors.green
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                incrementVotes(teamKey, currentVotes); // Cast the vote
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchLeaderboard() async {
    DataSnapshot snapshot = await leaderboardRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> leaderboardData =
          Map<String, dynamic>.from(snapshot.value as Map);
      var sortedLeaderboard = Map.fromEntries(
        leaderboardData.entries.toList()
          ..sort((a, b) {
            Map<String, dynamic> teamA =
                Map<String, dynamic>.from(a.value as Map);
            Map<String, dynamic> teamB =
                Map<String, dynamic>.from(b.value as Map);
            return (teamB['votes'] ?? 0).compareTo(teamA['votes'] ?? 0);
          }),
      );
      return sortedLeaderboard;
    } else {
      return {};
    }
  }

  Future<bool> hasVoted() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    DataSnapshot snapshot =
        await votersRef.child(email.replaceAll('.', ',')).get();
    return snapshot.exists;
  }

  void incrementVotes(String teamKey, int currentVotes) async {
    if (await hasVoted()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already voted')),
      );
      return;
    }

    // Increment the vote count
    leaderboardRef.child('$teamKey/votes').set(currentVotes + 1);

    // Mark the current user as having voted
    String email = FirebaseAuth.instance.currentUser!.email!;
    votersRef.child(email.replaceAll('.', ',')).set(widget.name);

    // Refresh the leaderboard
    await Future.delayed(Duration(milliseconds: 300));
    _refreshLeaderboard();
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meet and Greet 2.0 Poll",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "LEADERBOARD",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: Colors.green,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshLeaderboard,
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchLeaderboard(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No teams found."),
                    );
                  } else {
                    Map<String, dynamic> teams = snapshot.data!;

                    return ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        String teamKey = teams.keys.elementAt(index);
                        Map<String, dynamic> team =
                            Map<String, dynamic>.from(teams[teamKey]);

                        // Access the 'name' attribute of each team
                        String teamName = team['name'] ??
                            'Unknown Team'; // Provide a fallback if 'name' is missing
                        int votes = team['votes'] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: ListTile(
                              title: Text(
                                teamName,
                                style: GoogleFonts.poppins(
                                  fontSize: 19
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "Votes: ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.green
                                    ),
                                  ),
                                  Text(
                                    "$votes",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.green
                                    ),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () =>
                                    confirmVote(teamKey, teamName, votes),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green
                                  ),
                                  alignment: Alignment.center,
                                  width: 70,
                                  height: 35,
                                  child: Text(
                                    "VOTE",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
