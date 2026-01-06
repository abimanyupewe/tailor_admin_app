import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_admin_app/controllers/location_controller.dart';
import 'package:tailor_admin_app/screens/location/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';

class ManageLocationScreen extends StatelessWidget {
  const ManageLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
    final addressController = TextEditingController();
    final latController = TextEditingController();
    final longController = TextEditingController();

    // Sync controllers with observable values once loaded
    ever(controller.isLoading, (loading) {
      if (!loading) {
        addressController.text = controller.address.value;
        latController.text = controller.latitude.value.toString();
        longController.text = controller.longitude.value.toString();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Kelola Lokasi Toko',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Initial setup if not triggered by ever
        if (addressController.text.isEmpty &&
            controller.address.value.isNotEmpty) {
          addressController.text = controller.address.value;
          latController.text = controller.latitude.value.toString();
          longController.text = controller.longitude.value.toString();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Lengkap',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: longController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // Get current values or default
                          double currentLat =
                              double.tryParse(latController.text) ?? 0.0;
                          double currentLng =
                              double.tryParse(longController.text) ?? 0.0;

                          // Navigate to picker
                          final result = await Get.to(
                            () => LocationPickerScreen(
                              initialLat: currentLat,
                              initialLng: currentLng,
                            ),
                          );

                          // Handle result
                          if (result != null && result is LatLng) {
                            latController.text = result.latitude.toString();
                            longController.text = result.longitude.toString();
                            // Optional: Reverse geocode to get address could be added later
                          }
                        },
                        icon: const Icon(Iconsax.map),
                        label: Text(
                          'Pilih Lewat Peta',
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final lat =
                              double.tryParse(latController.text) ?? 0.0;
                          final lon =
                              double.tryParse(longController.text) ?? 0.0;
                          final addr = addressController.text;
                          controller.updateLocation(lat, lon, addr);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Simpan Lokasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tip: Anda bisa mendapatkan Latitude dan Longitude dari Google Maps\natau gunakan "Pilih Lewat Peta".',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
