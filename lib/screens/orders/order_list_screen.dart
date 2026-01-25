import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tailor_admin_app/controllers/order_controller.dart';

import 'package:tailor_admin_app/screens/orders/order_detail_screen.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Daftar Pesanan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        centerTitle: false,
        actions: const [],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.box_remove, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pesanan',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              final dateStr = order.createdAt.split('T').first;
              String formattedDate = dateStr;
              try {
                final date = DateTime.parse(order.createdAt);
                formattedDate = DateFormat('d MMM yyyy, HH:mm').format(date);
              } catch (_) {}

              return GestureDetector(
                onTap: () {
                  Get.to(() => OrderDetailScreen(order: order));
                },
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
                    children: [
                      // --- CARD HEADER ---
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#${order.id}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),

                      // --- CARD BODY ---
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F46E5).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.user,
                                color: Color(0xFF4F46E5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.userName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(order.totalPrice),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: const Color(
                                        0xFF10B981,
                                      ), // Emerald Green
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- CARD FOOTER (ACTIONS) ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // STATUS BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(order.status),
                                    size: 14,
                                    color: _getStatusColor(order.status),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    order.status.toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ACTION BUTTON
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showStatusDialog(
                                  context,
                                  controller,
                                  order.id,
                                  order.status,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Iconsax.edit,
                                        size: 16,
                                        color: Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Update Status",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    OrderController controller,
    int id,
    String currentStatus,
  ) {
    final statuses = [
      'PENDING',
      'ACCEPTED',
      'IN_PROGRESS',
      'COMPLETED',
      'CANCELLED',
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Status',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              ...statuses.map((status) {
                final isSelected = status == currentStatus.toUpperCase();
                return InkWell(
                  onTap: () {
                    controller.updateOrderStatus(id, status);
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4F46E5).withOpacity(0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF4F46E5))
                          : Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          color: isSelected
                              ? const Color(0xFF4F46E5)
                              : Colors.grey[400],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          status,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF4F46E5)
                                : Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Iconsax.tick_circle,
                            color: Color(0xFF4F46E5),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFF10B981); // Emerald
      case 'ACCEPTED':
        return const Color(0xFF3B82F6); // Blue
      case 'IN_PROGRESS':
        return const Color(0xFF6366F1); // Indigo
      case 'PENDING':
        return const Color(0xFFF59E0B); // Amber
      case 'CANCELLED':
      case 'REJECTED':
        return const Color(0xFFEF4444); // Red
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Iconsax.tick_circle;
      case 'ACCEPTED':
        return Iconsax.verify;
      case 'IN_PROGRESS':
        return Iconsax.timer;
      case 'PENDING':
        return Iconsax.clock;
      case 'CANCELLED':
      case 'REJECTED':
        return Iconsax.close_circle;
      default:
        return Iconsax.box;
    }
  }
}
