import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/profile_controller.dart';
import 'package:tailor_admin_app/screens/services/service_list_screen.dart';
import 'package:tailor_admin_app/screens/portfolio/portfolio_screen.dart';
import 'package:tailor_admin_app/screens/location/manage_location_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('Failed to load profile'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Text(
                        user.username.isNotEmpty
                            ? user.username[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Options
              _buildMenuOption(
                icon: Iconsax.scissor,
                title: 'Kelola Layanan',
                onTap: () => Get.to(() => const ServiceListScreen()),
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Iconsax.gallery,
                title: 'Kelola Portofolio',
                onTap: () => Get.to(() => const PortfolioScreen()),
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Iconsax.location,
                title: 'Kelola Lokasi Toko',
                onTap: () => Get.to(() => const ManageLocationScreen()),
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Iconsax.edit,
                title: 'Edit Profile',
                onTap: () {
                  Get.snackbar('Info', 'Fitur Edit Profile akan segera hadir');
                },
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Iconsax.logout,
                title: 'Logout',
                color: Colors.red,
                onTap: controller.logout,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
