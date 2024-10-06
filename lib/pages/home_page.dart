// ignore_for_file: prefer_const_constructors

import 'package:android_club_app/pages/DefaultEventDetail.dart';
import 'package:android_club_app/pages/reg_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_club_app/widgets/userDetDialog.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_club_app/widgets/app_bar.dart';
import 'package:android_club_app/widgets/animation_custom1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _incompleteBannerUrls = [];
  List<String> _recentCompleteBannerUrls = [];
  List<String> _eventId = []; // For upcoming events
  List<String> _recentEventIds = []; // For recent events

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
          final docSnapshot = await userDoc.get();

          if (docSnapshot.exists) {
            // No action needed if user exists
          } else {
            setState(() {
              _isLoading = false;
            });
            showUserDetailsDialog(context, user);
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
            _errorMessage = "Error checking user data: $e";
          });
          print(_errorMessage);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });

    _fetchEventBanners();
  }

  Future<void> _fetchEventBanners() async {
    try {
      // Fetch events where completion is false (Upcoming events)
      QuerySnapshot incompleteSnapshot = await _firestore
          .collection('events')
          .where('completion', isEqualTo: false)
          .get();

      List<String> incompleteUrls = incompleteSnapshot.docs.map((doc) {
        return doc['bannerURL'] as String;
      }).toList();

      List<String> eventIds = incompleteSnapshot.docs.map((doc) {
        return doc['notificationGroup'] as String; // Get event IDs for upcoming events
      }).toList();

      // Fetch the five most recent events where completion is true (Recent events)
      QuerySnapshot recentCompleteSnapshot = await _firestore
          .collection('events')
          .where('completion', isEqualTo: true)
          .limit(5)
          .get();

      List<String> recentCompleteUrls = recentCompleteSnapshot.docs.map((doc) {
        return doc['bannerURL'] as String;
      }).toList();

      // Event IDs for recent events
      List<String> recentEventIds = recentCompleteSnapshot.docs.map((doc) {
        return doc['notificationGroup'] as String; // Get event IDs for recent events
      }).toList();

      // Update state with fetched banner URLs and event IDs
      setState(() {
        _incompleteBannerUrls = incompleteUrls;
        _eventId = eventIds; // For upcoming events
        _recentCompleteBannerUrls = recentCompleteUrls; // For recent event banners
        _recentEventIds = recentEventIds; // For recent event IDs
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching banner URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroAppBar(
        pageTitle: '',
        isHomePage: true,
      ),
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
            : SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 18),

                      // Current/Upcoming Events
                      if (_incompleteBannerUrls.isNotEmpty) ...[
                        Container(
                          child: Text(
                            "UPCOMING EVENTS",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: CarouselSlider.builder(
                            itemCount: _incompleteBannerUrls.length,
                            itemBuilder: (context, index, realIndex) {
                              final urlImage =
                              _incompleteBannerUrls[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    Animation1Route(
                                      enterWidget: RegForm(
                                        eventId: _eventId[index],
                                        imageUrl:
                                        _incompleteBannerUrls[
                                        index],
                                      ),
                                      hor: 0.0,
                                      ver: -0.3,
                                    ),
                                  );
                                },
                                child: buildImage(urlImage, index),
                              );
                            },
                            options: CarouselOptions(
                              height: 300,
                              aspectRatio: 1 / 1,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              enableInfiniteScroll:
                              _incompleteBannerUrls.length > 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],

                      // Past Events
                      SizedBox(height: 24),
                      Container(
                        child: Text(
                          "RECENT EVENTS",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: CarouselSlider.builder(
                          itemCount:
                          _recentCompleteBannerUrls.length,
                          itemBuilder:
                              (context, index, realIndex) {
                            final urlImage =
                            _recentCompleteBannerUrls[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  Animation1Route(
                                    enterWidget: Defaulteventdetail(
                                      eventId: _recentEventIds[index], // Use correct eventId for recent events
                                      imageUrl:
                                      _recentCompleteBannerUrls[
                                      index],
                                    ),
                                    hor: 0.0,
                                    ver: -0.3,
                                  ),
                                );
                              },
                              child: buildImage(urlImage, index),
                            );
                          },
                          options: CarouselOptions(
                            height: 350,
                            aspectRatio: 1 / 1,
                            initialPage: 3,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 4),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

