import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_admin_app/controllers/order_controller.dart';
import 'package:tailor_admin_app/widgets/custom_data_table.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Orders',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: controller.fetchOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: controller.orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Text('#${order.id}')),
                        DataCell(Text(order.userName)),
                        DataCell(
                          Text('\$${order.totalPrice.toStringAsFixed(2)}'),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () {
                              _showStatusDialog(
                                context,
                                controller,
                                order.id,
                                order.status,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    order.status,
                                    style: TextStyle(
                                      color: _getStatusColor(order.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: _getStatusColor(order.status),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(order.createdAt.split('T').first),
                        ), // Simple date format
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
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
      AlertDialog(
        title: const Text('Update Status Pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses
              .map(
                (status) => ListTile(
                  title: Text(status),
                  leading: Radio<String>(
                    value: status,
                    groupValue: currentStatus.toUpperCase(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.updateOrderStatus(id, val);
                        Get.back(); // Close dialog
                      }
                    },
                  ),
                  onTap: () {
                    controller.updateOrderStatus(id, status);
                    Get.back();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'accepted':
        return Colors.teal;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
