 // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_club_app/auth/firebase_auth/CheckAuth.dart';
import 'package:android_club_app/auth/firebase_auth/firebase_auth_implement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
 import 'package:android_club_app/auth/firebase_auth/AuthService.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    super.key,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final AuthService _authService = AuthService();
  final FirebaseAuthImplement auth = FirebaseAuthImplement();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp() {}

  @override
  Widget build(BuildContext context) {
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

              Text("Welcome!",
                  style: GoogleFonts.bebasNeue(
                      fontSize: 58,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFb9d98d) // For dark mode
                          : const Color(0xFF222222))
              ),

              // Intro Text
              Text(
                "First Time? Let's get you Signed up!",
                style: TextStyle(fontSize: 16),
              ),

              // spacing between
              SizedBox(height: 20.0),

              // Email TextField
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Name",
                ),
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

              // spacing between
              SizedBox(height: 20.0),

              // Password TextField
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Confirm Password",
                ),
                obscureText: true,
              ),

              // Spacing
              SizedBox(height: 20.0),

              // Log In Button
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
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
                  Text(
                    "Already a member? ",
                    style: GoogleFonts.poppins(
                        // color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pop(context)
                    },
                    child: Text(
                      "Log In",
                      style: GoogleFonts.poppins(
                          // color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),

              SizedBox(height: 15.0),

              // Other login methods icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(width: 10,),
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

  void _signUp() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password!= confirmPassword) {
      print("Passwords do not match");
      return;
    }

    User? user = await auth.signUpWithEmailAndPassword(email, password);
    if (user!= null) {
      print("User Created");
      // You can also navigate to the home page or perform other actions here
    } else {
      print("Error creating user");
    }
  }

}
