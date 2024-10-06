// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_club_app/pages/about_us_page.dart';
import 'package:android_club_app/pages/home_page.dart';
import 'package:android_club_app/pages/polls_page.dart';
import 'package:android_club_app/pages/quiz_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // List of Screens
  List screens = [QuizPage(), HomePage(), PollsPage()];
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.background,
        animationDuration: Duration(milliseconds: 400),
        items: [
          CurvedNavigationBarItem(
              child: Icon(
                Icons.quiz_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFb9d98d) // For dark mode
                    : const Color(0xFF222222),
              ),
              label: "Qwiz",
              labelStyle: GoogleFonts.poppins(),
          ),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFb9d98d) // For dark mode
                    : const Color(0xFF222222),
              ),
              label: "Home",
              labelStyle: GoogleFonts.poppins(),
          ),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.poll_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFb9d98d) // For dark mode
                    : const Color(0xFF222222),
              ),
              label: "Polls",
              labelStyle: GoogleFonts.poppins(),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: screens[_selectedIndex],
    );
  }
}
