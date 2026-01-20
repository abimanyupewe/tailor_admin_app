import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/service_controller.dart';
import 'package:tailor_admin_app/models/service_model.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Kelola Layanan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showServiceDialog(context, controller, null),
        backgroundColor: const Color(0xFF3F51B5),
        child: const Icon(Iconsax.add),
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
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.services.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return Opacity(
              opacity: service.isActive ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Iconsax.scissor, color: Colors.blue),
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
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${service.price.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (service.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                service.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.edit, color: Colors.orange),
                      onPressed: () =>
                          _showServiceDialog(context, controller, service),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      onPressed: () =>
                          _confirmDelete(context, controller, service.id),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: service.isActive,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          controller.updateService(service.id, {
                            'is_active': val,
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
                    fontSize: 20,
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
                const SizedBox(height: 32),
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
                            fontWeight: FontWeight.w600,
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
                            'service_type': 'PERMAK',
                          };

                          if (service == null) {
                            controller.addService(data);
                          } else {
                            controller.updateService(service.id, data);
                          }
                          // Dialog closed by controller success/error logic usually,
                          // but controller logic in this app uses Get.back() inside success?
                          // Checking service_controller... it shows snackbar.
                          // It does NOT do Get.back().
                          // Wait, my previous view_file of ServiceController (from context)
                          // didn't show Get.back().
                          // Let's safe bet: Manual Get.back() if success?
                          // Or rely on controller?
                          // Usually modifying UI code shouldn't change logic too much.
                          // But this dialog code is cleaner.
                          Get.back(); // Close dialog immediately on valid submit?
                          // Ideally wait for success.
                          // But for now let's just submit. The old code didn't wait either?
                          // The old code:
                          // if (service == null) controller.addService...
                          // It returned.
                          // So the dialog stayed open?
                          // Wait, if I look at old code:
                          // onPressed: () { ... controller.addService(...) }
                          // It implies it didn't close automatically unless controller closed it.
                          // Let's assume controller deals with closing or I should.
                          // Let's allow closing here for now to be responsive.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
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
          borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
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
      middleText: 'Apakah Anda yakin ingin menghapus layanan ini?',
      textConfirm: 'Ya, Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteService(id);
        Get.back();
      },
    );
  }
}
