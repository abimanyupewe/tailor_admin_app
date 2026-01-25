import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tailor_admin_app/widgets/stat_card.dart';
import 'package:tailor_admin_app/controllers/overview_controller.dart';
import 'package:tailor_admin_app/screens/services/service_list_screen.dart';
import 'package:tailor_admin_app/screens/portfolio/portfolio_screen.dart';
import 'package:tailor_admin_app/screens/location/manage_location_screen.dart';
import 'package:tailor_admin_app/screens/analytics/analytics_screen.dart';
import 'package:tailor_admin_app/screens/orders/order_list_screen.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OverviewController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Lighter, more premium bg
      body: Stack(
        children: [
          // --- BACKGROUND DECORATIONS ---
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.05),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.05),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.fetchSummary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang,',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.username.value.isNotEmpty
                                    ? controller.username.value
                                    : 'Tailor',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const Icon(
                              Iconsax.notification,
                              color: Color(0xFF1E293B),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- PENDING ACTION BANNER ---
                      if (controller.pendingOrders.value > 0) ...[
                        GestureDetector(
                          onTap: () {
                            // Navigate to Orders tab (index 1) typically,
                            // but since we are inside a tab currently, we might want to switch tabs or push screen.
                            // Ideally switch tab. For now, pushing OrderListScreen is explicit.
                            Get.to(() => const OrderListScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Iconsax.warning_2,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.pendingOrders.value} Pesanan Baru",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.orange[900],
                                        ),
                                      ),
                                      Text(
                                        "Menunggu konfirmasi Anda",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Colors.orange[800]
                                              ?.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Iconsax.arrow_right_3,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // --- STATS GRID ---
                      Text(
                        'Ringkasan Bisnis',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        childAspectRatio:
                            1.3, // Give more height to prevent overflow
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          StatCard(
                            title: 'Total Pesanan',
                            value: '${controller.totalOrders.value}',
                            icon: Iconsax.box,
                            color: const Color(0xFF3B82F6), // Blue
                          ),
                          StatCard(
                            title: 'Pendapatan',
                            value:
                                'Rp ${NumberFormat.compact(locale: 'id').format(controller.totalRevenue.value)}', // Compact format
                            icon: Iconsax.money,
                            color: const Color(0xFF10B981), // Emerald
                          ),
                          StatCard(
                            title: 'Pesanan Aktif',
                            value: '${controller.activeOrders.value}',
                            icon: Iconsax.timer,
                            color: const Color(0xFFF59E0B), // Amber
                          ),
                          StatCard(
                            title: 'Rating Toko',
                            value: controller.rating.value > 0
                                ? controller.rating.value.toStringAsFixed(1)
                                : '-',
                            icon: Iconsax.star,
                            color: const Color(0xFF8B5CF6), // Violet
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- QUICK ACCESS (Keep as requested) ---
                      Text(
                        'Akses Cepat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildQuickAction(
                              icon: Iconsax.scissor,
                              label: 'Layanan',
                              color: const Color(0xFF3B82F6),
                              onTap: () =>
                                  Get.to(() => const ServiceListScreen()),
                            ),
                            const SizedBox(width: 16),
                            _buildQuickAction(
                              icon: Iconsax.gallery,
                              label: 'Postingan',
                              color: const Color(0xFF8B5CF6),
                              onTap: () =>
                                  Get.to(() => const PortfolioScreen()),
                              isHighlighted: true, // Example highlight
                            ),
                            const SizedBox(width: 16),
                            _buildQuickAction(
                              icon: Iconsax.chart_2,
                              label: 'Analitik',
                              color: const Color(0xFFF59E0B),
                              onTap: () =>
                                  Get.to(() => const AnalyticsScreen()),
                            ),
                            const SizedBox(width: 16),
                            _buildQuickAction(
                              icon: Iconsax.location,
                              label: 'Lokasi',
                              color: const Color(0xFFEF4444),
                              onTap: () =>
                                  Get.to(() => const ManageLocationScreen()),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- RECENT ORDERS ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pesanan Terbaru',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Get.to(() => const OrderListScreen()),
                            child: Text(
                              'Lihat Semua',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 8), // Spacing handled by ListView
                      if (controller.recentOrders.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "Belum ada pesanan terbaru",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.recentOrders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final order = controller.recentOrders[index];
                            // Safety parsing
                            final orderBy =
                                order['order_by_username'] ?? 'Pelanggan';
                            final status = (order['status'] ?? '')
                                .toString()
                                .toUpperCase();
                            final total =
                                double.tryParse(
                                  (order['total_price'] ?? '0').toString(),
                                ) ??
                                0.0;
                            final dateStr =
                                order['created_at']; // Assuming ISO string

                            String formattedDate = '';
                            if (dateStr != null) {
                              try {
                                final date = DateTime.parse(dateStr);
                                formattedDate = DateFormat(
                                  'd MMM, HH:mm',
                                ).format(date);
                              } catch (_) {}
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      status,
                                    ).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getStatusIcon(status),
                                    color: _getStatusColor(status),
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  orderBy,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                subtitle: Text(
                                  formattedDate.isNotEmpty
                                      ? formattedDate
                                      : status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(total),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100, // Fixed width for horizontal scroll items
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted
              ? Border.all(color: color.withOpacity(0.3), width: 1.5)
              : null,
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Iconsax.timer;
      case 'ACCEPTED':
        return Iconsax.verify;
      case 'IN_PROGRESS':
        return Iconsax.scissor; // Or processing icon
      case 'COMPLETED':
        return Iconsax.tick_circle;
      case 'CANCELLED':
      case 'REJECTED':
        return Iconsax.close_circle;
      default:
        return Iconsax.box;
    }
  }
}
