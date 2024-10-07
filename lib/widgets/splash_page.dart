import 'package:android_club_app/auth/firebase_auth/CheckAuth.dart';
import 'package:android_club_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the splash video
    _controller = VideoPlayerController.asset('assets/images/splash.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI after initialization
        _controller.play(); // Automatically start playing the video
      });

    _controller.setLooping(false); // Video won't loop by default

    // Listener to detect when the video completes
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Navigate to BottomNav page when the video finishes
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CheckAuth()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3528), // Set your custom background color
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(), // Display an empty container until the video is ready
      ),
    );
  }
}
