import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_admin_app/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or App Name
            Text(
              'Tailor Admin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3F51B5),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Color(0xFF3F51B5)),
          ],
        ),
      ),
    );
  }
}
