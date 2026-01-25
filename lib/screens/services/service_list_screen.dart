import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/service_controller.dart';
import 'package:tailor_admin_app/models/service_model.dart';
import 'package:intl/intl.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Kelola Layanan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showServiceDialog(context, controller, null),
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.scissor, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada layanan',
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
          onRefresh: controller.fetchServices,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.services.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return Opacity(
                opacity: service.isActive ? 1.0 : 0.6,
                child: Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Iconsax.scissor,
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
                                  service.name,
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
                                  ).format(service.price),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                                if (service.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    service.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.timer_1,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      service.duration,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: service.isActive,
                                  activeColor: const Color(0xFF10B981),
                                  onChanged: (val) {
                                    controller.updateService(service.id, {
                                      'is_active': val,
                                    });
                                  },
                                ),
                              ),
                              Text(
                                service.isActive ? 'Aktif' : 'Non-Aktif',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: service.isActive
                                      ? Colors.grey[700]
                                      : Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Iconsax.edit,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                                onPressed: () => _showServiceDialog(
                                  context,
                                  controller,
                                  service,
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Iconsax.trash,
                                  color: Color(0xFFEF4444),
                                  size: 20,
                                ),
                                onPressed: () => _confirmDelete(
                                  context,
                                  controller,
                                  service.id,
                                ),
                              ),
                            ],
                          ),
                        ],
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

  void _showServiceDialog(
    BuildContext context,
    ServiceController controller,
    ServiceModel? service,
  ) {
    final nameController = TextEditingController(text: service?.name);
    String priceText = '';
    if (service != null) {
      if (service.price % 1 == 0) {
        priceText = service.price.toInt().toString();
      } else {
        priceText = service.price.toString();
      }
    }

    final priceController = TextEditingController(text: priceText);
    final descController = TextEditingController(text: service?.description);
    final durationController = TextEditingController(text: service?.duration);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  service == null ? 'Tambah Layanan' : 'Edit Layanan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildModernTextField(
                  controller: nameController,
                  label: 'Nama Layanan',
                  icon: Iconsax.scissor,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: priceController,
                  label: 'Harga (Rp)',
                  icon: Iconsax.money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: descController,
                  label: 'Deskripsi (Opsional)',
                  icon: Iconsax.note,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: durationController,
                  label: 'Durasi (misal: 2 Hari)',
                  icon: Iconsax.timer,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Nama layanan tidak boleh kosong',
                              backgroundColor: Colors.red[100],
                              colorText: Colors.red,
                            );
                            return;
                          }

                          final price = double.tryParse(priceController.text);
                          if (price == null || price <= 0) {
                            Get.snackbar(
                              'Error',
                              'Harga harus valid > 0',
                              backgroundColor: Colors.red[100],
                              colorText: Colors.red,
                            );
                            return;
                          }

                          if (durationController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Durasi tidak boleh kosong',
                              backgroundColor: Colors.red[100],
                              colorText: Colors.red,
                            );
                            return;
                          }

                          int durationDays = 1;
                          final durationText = durationController.text
                              .replaceAll(RegExp(r'[^0-9]'), '');
                          if (durationText.isNotEmpty) {
                            durationDays = int.tryParse(durationText) ?? 1;
                          }

                          final data = {
                            'name': nameController.text,
                            'base_price': price,
                            'description': descController.text,
                            'estimated_duration_days': durationDays,
                            'service_type': 'PERMAK', // Default
                          };

                          if (service == null) {
                            controller.addService(data);
                          } else {
                            controller.updateService(service.id, data);
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFF1E293B),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ServiceController controller,
    int id,
  ) {
    Get.defaultDialog(
      title: 'Hapus Layanan',
      titleStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
      middleText: 'Apakah Anda yakin ingin menghapus layanan ini?',
      middleTextStyle: GoogleFonts.plusJakartaSans(),
      textConfirm: 'Ya, Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      cancelTextColor: Colors.grey[700],
      onConfirm: () {
        controller.deleteService(id);
        Get.back();
      },
    );
  }
}
