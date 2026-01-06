import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/widgets/stat_card.dart';
import 'package:tailor_admin_app/controllers/overview_controller.dart';
import 'package:tailor_admin_app/screens/services/service_list_screen.dart';
import 'package:tailor_admin_app/screens/portfolio/portfolio_screen.dart';
import 'package:tailor_admin_app/screens/location/manage_location_screen.dart';
import 'package:tailor_admin_app/screens/analytics/analytics_screen.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OverviewController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo,',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.username.value.isNotEmpty
                            ? controller.username.value
                            : 'Tailor',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Statistik Toko',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      title: 'Total Pesanan',
                      value: '${controller.totalOrders.value}',
                      icon: Iconsax.box,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: 'Pendapatan',
                      value:
                          'Rp ${controller.totalRevenue.value.toStringAsFixed(0)}',
                      icon: Iconsax.money,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: 'Pesanan Aktif',
                      value: '${controller.activeOrders.value}',
                      icon: Iconsax.timer,
                      color: Colors.blue,
                    ),
                    // Placeholder for rating or other stats not yet in API summary
                    // Placeholder for rating or other stats not yet in API summary
                    StatCard(
                      title: 'Rating',
                      value: controller.rating.value.toStringAsFixed(1),
                      icon: Iconsax.star,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Akses Cepat',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  childAspectRatio: 1.0,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildQuickAction(
                      icon: Iconsax.chart_2, // Analitik
                      label: 'Analitik',
                      color: Colors.orange,
                      onTap: () => Get.to(() => const AnalyticsScreen()),
                    ),
                    _buildQuickAction(
                      icon: Iconsax.scissor,
                      label: 'Layanan',
                      color: Colors.blue,
                      onTap: () => Get.to(() => const ServiceListScreen()),
                    ),
                    _buildQuickAction(
                      icon: Iconsax.gallery,
                      label: 'Postingan', // Ubah Portofolio jadi Postingan
                      color: Colors.purple,
                      onTap: () => Get.to(() => const PortfolioScreen()),
                    ),
                    _buildQuickAction(
                      icon: Iconsax.location,
                      label: 'Lokasi',
                      color: Colors.red,
                      onTap: () => Get.to(() => const ManageLocationScreen()),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
