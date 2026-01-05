import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/widgets/stat_card.dart';
import 'package:tailor_admin_app/controllers/overview_controller.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OverviewController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Overview',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onSelected: controller.updateRange,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('7 Hari Terakhir')),
              const PopupMenuItem(value: 30, child: Text('30 Hari Terakhir')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  const StatCard(
                    title: 'Rating',
                    value: '4.8',
                    icon: Iconsax.star,
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
