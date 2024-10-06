
import 'package:android_club_app/theme/light_mode.dart';
import 'package:android_club_app/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/CheckAuth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_club_app/models/user.dart';
import 'package:android_club_app/widgets/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black, //Status Bar Color
    ),
  );

  Hive.registerAdapter(AppUserAdapter());
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}