import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'scan_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        // child: Container(
        //   // decoration: BoxDecoration(
        //   //   boxShadow: [
        //   //     BoxShadow(
        //   //       color: Colors.black.withOpacity(0.05),
        //   //       spreadRadius: 2,
        //   //       blurRadius: 4,
        //   //       offset: const Offset(0, 2),
        //   //     ),
        //   //   ],
        //   // ),
        child: AppBar(
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/Lottie Lego (3).json',
                height: 350,
                fit: BoxFit.cover,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Lego',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0XFF0FCCCE),
                          fontFamily: GoogleFonts.dmSans().fontFamily),
                    ),
                    TextSpan(
                      text: 'Craft',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFDB813),
                          fontFamily: GoogleFonts.dmSans().fontFamily),
                    ),
                    TextSpan(
                      text: 'Ai',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC41E3A),
                          fontFamily: GoogleFonts.dmSans().fontFamily),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      height: 1.3,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'upload a picture of your legos and Create wonder builds effortlessly with your child',
                        style: TextStyle(
                          fontFamily: GoogleFonts.dmSans().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(102, 102, 102, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(297, 43),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    backgroundColor: const Color(0xFFFDB813),
                  ),
                  child: Text(
                    "Let's Get Started !",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
