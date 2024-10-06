// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:android_club_app/auth/firebase_auth/firebase_auth_implement.dart';
import 'package:android_club_app/auth/firebase_auth/signup_page.dart';
import 'package:android_club_app/auth/firebase_auth/AuthService.dart';
import 'package:android_club_app/auth/firebase_auth/CheckAuth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _authService = AuthService();

  final FirebaseAuthImplement auth = FirebaseAuthImplement();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // void redirectToForgotPassword() {}

  @override
  Widget build(BuildContext context) {
    var context2 = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.android,
                size: 100.0,
                color: Colors.green,
              ),

              // Intro Text
              Text("HELLO THERE!",
                  style: GoogleFonts.bebasNeue(
                      fontSize: 58)),

              Text(
                "Welcome to Android Club App!",
                style: TextStyle(fontSize: 16),
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "E-mail",
                ),
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Password TextField
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Password",
                ),
                obscureText: true,
              ),

              // Spacing
              SizedBox(
                height: 15.0,
              ),

              // Forgot Password Text
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: redirectToForgotPassword,
              //       child: Text("Forgot Password?"),
              //     ),
              //   ],
              // ),

              // Spacing
              SizedBox(height: 15.0),

              // Log In Button
              GestureDetector(
                onTap: login,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: Text(
                          "SIGN IN",
                          style: GoogleFonts.poppins(
                            // color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),
              ),

              // Spacing
              SizedBox(height: 15.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("First time here? ",
                      style: GoogleFonts.poppins(
                      fontSize: 16)),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupPage())
                      )
                    },
                    child: Text(
                      "Register now",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Other login methods icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _authService.signInWithGoogle();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckAuth()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/google_logo.png',
                      width: 50,
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () async {
                      await _authService.signInWithGitHub();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckAuth()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/github_logo.png',
                      width: 50,
                    ),
                  ),
                ],
              ),

              // Spacing
              SizedBox(height: 15.0),

              // Register Now redirect

            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("User Logged In");
    } else {
      print("Error logging in");
    }
  }

  // Future<UserCredential> signInWithGitHub() async {
  //   try {
  //     final GithubAuthProvider githubProvider = GithubAuthProvider();
  //     final UserCredential result = await _firebaseAuth.signInWithProvider(githubProvider);
  //     final User? user = result.user;
  //     if (user != null) {
  //       print("GitHub login successful: ${user.uid}");
  //       return result;
  //     } else {
  //       throw FirebaseAuthException(code: 'ERROR', message: 'GitHub sign-in failed');
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     rethrow;
  //   }
  // }


}
