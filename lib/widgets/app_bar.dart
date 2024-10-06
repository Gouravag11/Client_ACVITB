import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android_club_app/widgets/animation_custom1.dart';
import 'package:android_club_app/pages/user_info_page.dart';
import 'package:android_club_app/pages/ranking_page.dart';
import 'package:android_club_app/pages/quiz_page.dart';
import 'package:android_club_app/models/user.dart';
import 'package:android_club_app/auth/user_data_manager.dart';


class AndroAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool isHomePage;
  final bool clickableIcons;
  final bool showBack;

  const AndroAppBar({
    Key? key,
    required this.pageTitle,
    this.isHomePage = false,
    this.clickableIcons = true,
    this.showBack = false,

  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60); // Adjusted height
}

class _CustomAppBarState extends State<AndroAppBar> {
  String displayName = '';
  String profileURL = '';
  int droid = 0;
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final user = await UserDataManager.getUserData();
      if (user != null) {
        setState(() {
          _user = user;
          displayName = _user!.name.split(' ')[0];
          profileURL = _user!.profilePic;
          droid = _user!.droids;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    _setStatusBarColor();

  }

  void _setStatusBarColor() {
    final Brightness brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: brightness == Brightness.dark ? Colors.white12 : Colors.black45, // Same as your AppBar's background
      statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark, // Icons color
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PreferredSize(
        preferredSize: const Size.fromHeight(160), // App Bar Height
        child: AppBar(
          automaticallyImplyLeading: false, // Disable back button by default
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12 // For dark mode
              : Colors.black45,
          flexibleSpace: Container(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the items
              children: [
                // Title Container
                widget.isHomePage
                    ? Expanded( // If Home Page
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200, // Set the width to total width - 200
                      child: Wrap( // Use Wrap to wrap the contents
                        direction: Axis.horizontal,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Vertically center title
                            crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              // ),
                              Flexible( // Use Flexible to wrap the Text
                                child: Text(
                                  'Graciós!\n$displayName',
                                  textAlign: TextAlign.left, // Adjust text alignment
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Container( // Any other page except home
                  width: MediaQuery.of(context).size.width - 190, // Set the width to total width - 190
                  child: Wrap( // Use Wrap to wrap the contents
                    direction: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          widget.showBack
                              ? Transform.translate( // Use Transform to translate the Container when showBack is true
                            offset: const Offset(-20, 0), // Translate 20 pixels to the left
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white // For dark mode
                                  : Colors.black,),
                              onPressed: () => Navigator.pop(context), // Navigate back on tap
                            ),
                          )
                              : const SizedBox.shrink(),
                          Flexible( // Use Flexible to wrap the Text
                            child: widget.showBack
                                ? Transform.translate( // Use Transform to translate the Text when showBack is true
                              offset: const Offset(-20, 0), // Translate 20 pixels to the left
                              child: Text(
                                widget.pageTitle,
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                                : Text(
                              widget.pageTitle,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Profile Avatar
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: !widget.clickableIcons ? null : () { // null when false
                            Navigator.of(context).push(
                              Animation1Route(
                                  enterWidget: const RankingPage(),
                                  hor: 0.45,
                                  ver: -0.85
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white12 // For dark mode
                                  : Colors.black26, // Light background color
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.android, // Android icon
                                  size: 25.0, // Adjust the size of the icon as needed
                                  color: Colors.green, // Adjust the color of the icon
                                ),
                                const SizedBox(width: 8), // Space between the icon and the text
                                Text(
                                  droid.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        GestureDetector(
                          onTap: !widget.clickableIcons ? null : () { // null when false
                            Navigator.of(context).push(
                              Animation1Route(
                                  enterWidget: const UserInfoPage(), //  Transition when true
                                  hor: 0.8,
                                  ver: -0.85
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileURL),
                            radius: 20, // Adjust the size of the profile picture
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
