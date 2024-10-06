import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail(String email) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (!await launchUrl(emailUri)) {
      throw 'Could not send email to $email';
    }
  }

  Widget buildMember({
    required String name,
    required String position,
    required String bio,
    String? email,
    String? linkedIn,
    String? gitHub,
    String? profilePicture,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePicture != null
                        ? AssetImage(profilePicture)
                        : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        position,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                bio,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (email != null)
                    GestureDetector(
                      onTap: () {
                        _launchEmail(email);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/google_logo.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  if (gitHub != null)
                    GestureDetector(
                      onTap: () {
                        _launchUrl('https://github.com/$gitHub');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/github_logo.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  if (linkedIn != null)
                    GestureDetector(
                      onTap: () {
                        _launchUrl('https://linkedin.com/in/$linkedIn');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/linkedin_logo.jpg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AndroAppBar(
        pageTitle: 'About Us',
        showBack: true,
        clickableIcons: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Android Club',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Where innovation meets exploration!',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Established in 2019, our club has been a hub for Android enthusiasts and tech aficionados alike.',
                style: GoogleFonts.openSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'At Android Club Vit Bhopal, we don\'t just follow trends; we set them. Through immersive workshops, cutting-edge seminars, and collaborative projects, we empower our members to explore the limitless possibilities of Android development. From crafting sleek UI designs to mastering the intricacies of app development, we thrive on creativity and innovation.',
                style: GoogleFonts.openSans(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 50,
                      height: 2,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                  Text(
                    'The Heads',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 50,
                      height: 2,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ],
              ),

              // Admin Members
              buildMember(
                name: 'Harsh Raj',
                position: 'Club President',
                bio:
                'The heart and soul of our Android Club. As president, he exemplifies unparalleled leadership and dedication. With a knack for tackling both technical challenges and life’s hurdles, Harsh is the go-to person for all things Android and beyond.',
                email: 'harsh.raj2021@vitbhopal.ac.in',
                linkedIn: 'harsh-raj-51475021b',
                gitHub: 'harshraj',
                profilePicture: 'assets/images/HarshRaj.jpg',
              ),
              buildMember(
                name: 'Giriraj Parsewar',
                position: 'Vice President',
                bio:
                'Introducing Giriraj Pradeep Parsewar our Vice President and a cornerstone of the Android Club. With a blend of technical expertise and strategic thinking, he seamlessly supports the president while driving forward the club\'s initiatives.',
                email: 'girirajpradeepparsewar2022@vitbhopal.ac.in',
                linkedIn: 'giriraj-parsewar-07939a1a9',
                gitHub: 'girirajpradeep',
                profilePicture: 'assets/images/Giriraj.jpg',
              ),
              buildMember(
                name: 'Avyaan Verma',
                position: 'General Secretary',
                bio:
                'Say hello to Avyaan Verma, the General Secretary of our Android Club. Avyaan’s exceptional communication skills and organizational prowess keep the club connected and informed.',
                email: 'avyaanverma2022@vitbhopal.ac.in',
                linkedIn: 'avyaanverma',
                gitHub: 'avyaanverma',
                profilePicture: 'assets/images/Avyaan.jpg',
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 50,
                      height: 2,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                  Text(
                    'Club Leads',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 50,
                      height: 2,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ],
              ),

              // Executive Board Members
              buildMember(
                name: 'Antareep Dey',
                position: 'Operations Lead',
                bio:
                'The backbone of our logistical and operational success. Antareep’s meticulous planning and exceptional problem-solving skills keep the club running like a well-oiled machine.',
                email: 'antareepdey2022@vitbhopal.ac.in',
                linkedIn: 'antareepdey',
                gitHub: 'antareepdey',
                profilePicture: 'assets/images/AntareepDey_operations_lead.png',
              ),
              buildMember(
                name: 'Samriddhi Tripathi',
                position: 'Operations Manager',
                bio:
                'Excelling as our Operations Manager, Samriddhi manages the day-to-day operations with precision and care. Her proactive approach ensures that everything runs seamlessly.',
                email: 'samriddhitripathi2022@vitbhopal.ac.in',
                linkedIn: 'samriddhitripathi',
                gitHub: 'samriddhitripathi',
                profilePicture: 'assets/images/Samriddhi Tripathi.jpg',
              ),
              buildMember(
                name: 'Arrohi Srivastava',
                position: 'Tech Lead',
                bio:
                'At the helm of our technical endeavours, Arrohi leads the Technical Department of our Club. She constantly pushes the boundaries of what’s possible in Android development.',
                email: 'arrohisrivastava2022@vitbhopal.ac.in',
                linkedIn: 'arrohi-srivastava',
                gitHub: 'arrohisrivastava',
                profilePicture: 'assets/images/Arrohi Srivastava.jpg',
              ),
              buildMember(
                name: 'Sparsh Tiwari',
                position: 'Tech Co-lead',
                bio:
                'A dynamic individual whose technical acumen and collaborative spirit make him the perfect Co-Lead for our Technical Department.',
                email: 'sparshtiwari2022@vitbhopal.ac.in',
                linkedIn: 'sparsh-tiwari-222739250',
                gitHub: 'sparsh',
                profilePicture: 'assets/images/Sparsh Tiwari.jpg',
              ),
              buildMember(
                name: 'Swastik Nanda',
                position: 'Non-Tech Lead',
                bio:
                'Introducing Swastik Nanda, our Non-Tech Lead, the creative force behind the Android Club’s non-technical initiatives. His exceptional organizational skills drive non-tech projects.',
                email: 'swastiknanda2022@vitbhopal.ac.in',
                linkedIn: 'swastik-nanda-837b35251',
                gitHub: 'swastiknanda',
                profilePicture: 'assets/images/Swastik Nanda.jpg',
              ),
              buildMember(
                name: 'Disha Gupta',
                position: 'Non-Tech Co-lead',
                bio:
                'With a talent for multitasking and creativity, Disha supports the Non-Tech Lead in executing non-technical operations. Her innovative ideas make her an essential part of the team.',
                email: 'dishagupta2022@vitbhopal.ac.in',
                linkedIn: 'disha-gupta-430174245',
                gitHub: 'dishagupta',
                profilePicture: 'assets/images/Disha Gupta.jpg',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
