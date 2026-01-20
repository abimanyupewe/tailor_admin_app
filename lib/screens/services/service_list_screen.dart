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
      // If price is an integer (e.g. 10000.0), display as 10000
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
      AlertDialog(
        title: Text(service == null ? 'Tambah Layanan' : 'Edit Layanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Layanan'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                ),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi (misal: 2 Hari)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
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
                  'Harga harus berupa angka valid dan lebih dari 0',
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

              // Parse duration to int
              int durationDays = 1;
              final durationText = durationController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              if (durationText.isNotEmpty) {
                durationDays = int.tryParse(durationText) ?? 1;
              }

              final data = {
                'name': nameController.text,
                'base_price': price, // Backend expects base_price
                'description': descController.text,
                'estimated_duration_days': durationDays, // Send as int
                'service_type': 'PERMAK', // Default value hidden from user
              };

              if (service == null) {
                controller.addService(data);
              } else {
                controller.updateService(service.id, data);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
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
