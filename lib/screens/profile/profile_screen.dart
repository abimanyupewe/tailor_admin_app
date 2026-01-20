import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/profile_controller.dart';
import 'package:tailor_admin_app/screens/services/service_list_screen.dart';
import 'package:tailor_admin_app/screens/portfolio/portfolio_screen.dart';
import 'package:tailor_admin_app/screens/location/manage_location_screen.dart';
import 'package:tailor_admin_app/screens/profile/edit_profile_screen.dart';
import 'package:tailor_admin_app/data/api_service.dart';
// Hapus import dart:io jika tidak dipakai di UI ini,
// tapi biarkan jika logic controller membutuhkannya.

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // Color Palette Modern
    const Color primaryBlue = Color(0xFF4F46E5);
    const Color secondaryBlue = Color(0xFF818CF8);
    const Color bgWhite = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgWhite,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        // Fallback jika user null (safety)
        if (user == null) {
          return const Center(child: Text("Data user tidak ditemukan"));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(), // Efek membal (iOS style)
          slivers: [
            // --- 1. INTERACTIVE HEADER (SLIVER) ---
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true, // Header tetap nempel di atas saat scroll
              backgroundColor: primaryBlue,
              elevation: 0,
              stretch: true, // Bisa ditarik (zoom effect)
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                title: Text(
                  user.username,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                // Saat di-scroll ke atas, ini yang akan tersembunyi
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Gradient Background
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [primaryBlue, Color(0xFF312E81)],
                        ),
                      ),
                    ),
                    // Dekorasi Lingkaran Abstrak (Agar estetik)
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Konten Profil Utama
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Avatar dengan Glow Effect
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            backgroundImage: user.avatar != null
                                ? NetworkImage(Get.find<ApiService>().getImageUrl(user.avatar))
                                : null,
                            child: user.avatar == null
                                ? Text(
                                    user.username.isNotEmpty
                                        ? user.username[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: primaryBlue,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Role Badge (Glassmorphism)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ), // Spasi agar tidak tertutup title
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. MENU ITEMS (ANIMATED LIST) ---
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section Title
                  _buildSectionHeader("Manajemen Toko"),
                  const SizedBox(height: 12),

                  // Menu Items dengan Animasi Masuk
                  _SlideInAnimation(
                    delay: 100,
                    child: _buildInteractiveCard(
                      icon: Iconsax.scissor,
                      title: 'Kelola Layanan',
                      subtitle: 'Daftar harga & jenis jahitan',
                      color: Colors.blue,
                      onTap: () => Get.to(() => const ServiceListScreen()),
                    ),
                  ),
                  _SlideInAnimation(
                    delay: 200,
                    child: _buildInteractiveCard(
                      icon: Iconsax.gallery,
                      title: 'Portofolio',
                      subtitle: 'Update hasil karya terbaru',
                      color: Colors.orange,
                      onTap: () => Get.to(() => const PortfolioScreen()),
                    ),
                  ),
                  _SlideInAnimation(
                    delay: 300,
                    child: _buildInteractiveCard(
                      icon: Iconsax.location,
                      title: 'Lokasi Toko',
                      subtitle: 'Setting alamat & maps',
                      color: Colors.purple,
                      onTap: () => Get.to(() => const ManageLocationScreen()),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Pengaturan Akun"),
                  const SizedBox(height: 12),

                  _SlideInAnimation(
                    delay: 400,
                    child: _buildInteractiveCard(
                      icon: Iconsax.edit,
                      title: 'Edit Profile',
                      subtitle: 'Ubah data diri Anda',
                      color: Colors.teal,
                      onTap: () => Get.to(() => const EditProfileScreen()),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SlideInAnimation(
                    delay: 500,
                    child: _buildInteractiveCard(
                      icon: Iconsax.logout,
                      title: 'Logout',
                      subtitle: 'Keluar aplikasi',
                      color: Colors.red,
                      isWarning: true,
                      onTap: controller.logout,
                    ),
                  ),

                  // Extra space di bawah agar scroll lebih lega
                  const SizedBox(height: 50),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget Card yang Responsive & Interaktif
  Widget _buildInteractiveCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isWarning
                              ? Colors.red
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Iconsax.arrow_circle_right,
                  color: Colors.grey[300],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET ANIMASI TAMBAHAN ---
// Widget kecil ini membuat efek "muncul dari bawah" tanpa perlu install package tambahan
class _SlideInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const _SlideInAnimation({required this.child, required this.delay});

  @override
  State<_SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<_SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Mulai sedikit dari bawah
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Jalankan animasi setelah delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _offsetAnimation, child: widget.child),
    );
  }
}
