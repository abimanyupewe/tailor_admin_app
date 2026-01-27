import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:tailor_admin_app/controllers/location_controller.dart';
import 'package:tailor_admin_app/screens/location/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';

class ManageLocationScreen extends StatefulWidget {
  const ManageLocationScreen({super.key});

  @override
  State<ManageLocationScreen> createState() => _ManageLocationScreenState();
}

class _ManageLocationScreenState extends State<ManageLocationScreen> {
  late LocationController controller;
  late TextEditingController addressController;
  late TextEditingController latController;
  late TextEditingController longController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LocationController());
    addressController = TextEditingController();
    latController = TextEditingController();
    longController = TextEditingController();

    // Populate initial values if available
    if (!controller.isLoading.value) {
      _updateControllers();
    }

    // Listen to changes to populate once loaded
    ever(controller.isLoading, (loading) {
      if (!loading) {
        _updateControllers();
      }
    });
  }

  void _updateControllers() {
    // Only update if controllers are empty to avoid overwriting user edits
    if (addressController.text.isEmpty) {
      addressController.text = controller.address.value;
    }
    if (latController.text.isEmpty && controller.latitude.value != 0.0) {
      latController.text = controller.latitude.value.toString();
    }
    if (longController.text.isEmpty && controller.longitude.value != 0.0) {
      longController.text = controller.longitude.value.toString();
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Kelola Lokasi Toko',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Lokasi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildModernTextField(
                      controller: addressController,
                      label: 'Alamat Lengkap',
                      icon: Iconsax.location,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernTextField(
                            controller: latController,
                            label: 'Latitude',
                            icon: Iconsax.global,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernTextField(
                            controller: longController,
                            label: 'Longitude',
                            icon: Iconsax.global,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          double currentLat =
                              double.tryParse(latController.text) ?? 0.0;
                          double currentLng =
                              double.tryParse(longController.text) ?? 0.0;

                          final result = await Get.to(
                            () => LocationPickerScreen(
                              initialLat: currentLat,
                              initialLng: currentLng,
                            ),
                          );

                          if (result != null) {
                            print('DEBUG: Received from Map: $result');
                            if (result is Map) {
                              final latlng = result['latlng'] as LatLng;
                              final address = result['address'] as String;

                              setState(() {
                                latController.text = latlng.latitude.toString();
                                longController.text = latlng.longitude
                                    .toString();
                                addressController.text = address;
                              });
                              print(
                                'DEBUG: Updated Controllers - Lat: ${latController.text}, Lon: ${longController.text}',
                              );
                            } else if (result is LatLng) {
                              setState(() {
                                latController.text = result.latitude.toString();
                                longController.text = result.longitude
                                    .toString();
                              });
                            }
                          }
                        },
                        icon: const Icon(Iconsax.map, size: 20),
                        label: Text(
                          'Pilih Lewat Peta',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: const Color(0xFF4F46E5).withOpacity(0.5),
                          ),
                          foregroundColor: const Color(0xFF4F46E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final lat = double.tryParse(latController.text) ?? 0.0;
                    final lon = double.tryParse(longController.text) ?? 0.0;
                    final addr = addressController.text;
                    print(
                      'DEBUG: ManageLocation Save Pressed. Values: Lat: $lat, Lon: $lon, Addr: $addr',
                    );
                    controller.updateLocation(lat, lon, addr);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    'Simpan Lokasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.info_circle,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tip: Gunakan fitur "Pilih Lewat Peta" untuk akurasi lokasi yang lebih baik.',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF1E3A8A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFF1E293B),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(
          0xFFF8FAFC,
        ), // F8FAFC matches the background, maybe use F1F5F9 for input?
        // Let's use F1F5F9 to distinguish from white card
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Icon(icon, color: Colors.grey[400], size: 20),
        ),
        alignLabelWithHint: true,
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
}
