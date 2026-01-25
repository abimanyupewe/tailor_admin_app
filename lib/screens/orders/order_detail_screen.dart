import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tailor_admin_app/controllers/order_controller.dart';
import 'package:tailor_admin_app/models/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderController controller = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    // Fetch full details (items, address, etc) on load
    controller.fetchOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Detail Pesanan #${widget.order.id}',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.message, color: Color(0xFF1E293B)),
            onPressed: () {
              // TODO: Open chat
              Get.snackbar('Info', 'Fitur Chat akan segera hadir');
            },
          ),
        ],
      ),
      body: Obx(() {
        // Use the fetched detailed order if available and matches ID, otherwise fallback to widget.order (summary)
        final detailedOrder = controller.selectedOrder.value;
        final isLoaded =
            detailedOrder != null && detailedOrder.id == widget.order.id;
        final displayOrder = isLoaded ? detailedOrder : widget.order;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- STATUS BANNER ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(displayOrder.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(
                      displayOrder.status,
                    ).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(displayOrder.status),
                      color: _getStatusColor(displayOrder.status),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      displayOrder.status.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _getStatusColor(displayOrder.status),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- CUSTOMER INFO ---
              _buildSectionHeader('Informasi Pelanggan'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
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
                    _buildInfoRow(Iconsax.user, 'Nama', displayOrder.userName),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    if (isLoaded && displayOrder.customerPhone != null) ...[
                      _buildInfoRow(
                        Iconsax.call,
                        'No. Telepon',
                        displayOrder.customerPhone!,
                        isLink: true,
                        onTap: () =>
                            _launchURL('tel:${displayOrder.customerPhone}'),
                      ),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    ],
                    _buildInfoRow(
                      Iconsax.location,
                      'Alamat',
                      (isLoaded && displayOrder.address != null)
                          ? displayOrder.address!
                          : 'Mengambil alamat...',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- ORDER ITEMS ---
              _buildSectionHeader('Daftar Layanan'),
              const SizedBox(height: 12),
              if (!isLoaded)
                const Center(child: CircularProgressIndicator())
              else if (displayOrder.items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Tidak ada detail item.",
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayOrder.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = displayOrder.items[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.serviceName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'x${item.quantity}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (item.note != null && item.note!.isNotEmpty)
                            Text(
                              'Catatan: ${item.note}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(item.price),
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 24),
              // --- SUMMARY ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(displayOrder.totalPrice),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      _showStatusDialog(context, displayOrder(controller)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Perbarui Status',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OrderModel displayOrder(OrderController c) {
    final detailed = c.selectedOrder.value;
    if (detailed != null && detailed.id == widget.order.id) return detailed;
    return widget.order;
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isLink = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return InkWell(
      onTap: isLink ? onTap : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isLink
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF1E293B),
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not launch $urlString');
    }
  }

  void _showStatusDialog(BuildContext context, OrderModel order) {
    // Re-use logic from list screen or define specialized logic here
    // Simple version:
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
                final isSelected = status == order.status.toUpperCase();
                return InkWell(
                  onTap: () {
                    controller.updateOrderStatus(order.id, status);
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
        return const Color(0xFF10B981);
      case 'ACCEPTED':
        return const Color(0xFF3B82F6);
      case 'IN_PROGRESS':
        return const Color(0xFF6366F1);
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'CANCELLED':
      case 'REJECTED':
        return const Color(0xFFEF4444);
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
