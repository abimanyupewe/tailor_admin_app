import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tailor_admin_app/controllers/onboarding_controller.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Kelola Pesanan",
          body: "Catat dan kelola pesanan pelanggan dengan mudah dan rapi.",
          image: _buildIcon(Iconsax.note_text),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Pantau Pendapatan",
          body:
              "Lihat statistik pemasukan harian dan bulanan secara real-time.",
          image: _buildIcon(Iconsax.graph),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Hubungi Pelanggan",
          body: "Fitur chat terintegrasi untuk komunikasi yang lebih lancar.",
          image: _buildIcon(Iconsax.message),
          decoration: _pageDecoration(),
        ),
      ],
      onDone: () => controller.completeOnboarding(),
      onSkip: () => controller.completeOnboarding(), // Skip also completes it
      showSkipButton: true,
      skip: const Text("Lewati", style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Mulai", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: AppColors.primary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 100, color: AppColors.primary),
    );
  }

  PageDecoration _pageDecoration() {
    return PageDecoration(
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        color: Colors.grey[600],
      ),
      imagePadding: const EdgeInsets.all(24),
    );
  }
}
