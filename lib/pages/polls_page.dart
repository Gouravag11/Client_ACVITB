// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:android_club_app/pages/poll_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomCodeController = TextEditingController();

  Future<bool> checkRoomExists(String roomCode) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref('polls/$roomCode');
    try {
      DataSnapshot snapshot = await reference.get();

      if (snapshot.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PollScreen(
              roomCode: roomCode,
              name: _nameController.text,
            ),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room Code does not exist')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ERROR' + e.toString())),
      );
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      _nameController.text = user.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroAppBar(
        pageTitle: 'Quiz Manager',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter a Room",
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _roomCodeController,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Room Code',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: GestureDetector(
                onTap: () async {
                  await checkRoomExists(_roomCodeController.text);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: Text(
                          "ENTER ROOM",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
