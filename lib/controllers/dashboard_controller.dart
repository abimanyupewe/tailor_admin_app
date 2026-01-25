import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:tailor_admin_app/controllers/profile_controller.dart';
import 'package:tailor_admin_app/screens/profile/edit_profile_screen.dart';

class DashboardController extends GetxController {
  final tabIndex = 0.obs;
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void onReady() {
    super.onReady();
    _checkProfileCompletion();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<void> _checkProfileCompletion() async {
    // Ensure we have the latest data
    if (_profileController.user.value == null) {
      await _profileController.fetchProfile();
    }

    final user = _profileController.user.value;
    if (user == null) return;

    bool isProfileIncomplete =
        (user.shopName == null || user.shopName!.isEmpty) ||
        (user.bio == null || user.bio!.isEmpty) ||
        (user.avatar == null && user.shopImage == null);

    if (isProfileIncomplete) {
      final prefs = await SharedPreferences.getInstance();
      final lastReminderTime = prefs.getInt('last_profile_reminder_time') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final checkInterval = 60 * 60 * 1000; // 1 hour

      if (currentTime - lastReminderTime > checkInterval) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.shop,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    "Lengkapi Profil Toko",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Body
                  Text(
                    "Toko yang lengkap 80% lebih dipercaya pelanggan. Yuk, upload foto, isi bio, dan lokasi toko sekarang!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        prefs.setInt('last_profile_reminder_time', currentTime);
                        Get.back();
                        Get.to(() => const EditProfileScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Lengkapi Sekarang",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      prefs.setInt('last_profile_reminder_time', currentTime);
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: Text(
                      "Nanti Saja",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    }
  }
}
