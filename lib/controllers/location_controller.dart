import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:tailor_admin_app/data/api_service.dart';

class LocationController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final isLoading = true.obs;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getMyLocation();
      if (response is Map) {
        print('DEBUG: LocationController fetch response: $response');
        latitude.value =
            double.tryParse(response['latitude'].toString()) ?? 0.0;
        longitude.value =
            double.tryParse(response['longitude'].toString()) ?? 0.0;
        address.value = response['address'] ?? '';
      }
    } catch (e) {
      // Ignore 404 if not set
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLocation(double lat, double lon, String addr) async {
    try {
      // Direct API Call - Backend is fixed!
      await _apiService.setMyLocation(lat, lon, addr);

      // Update UI
      latitude.value = lat;
      longitude.value = lon;
      address.value = addr;

      Get.snackbar(
        'Sukses',
        'Lokasi berhasil diperbarui',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 12,
      );
      
      // Give time for snackbar to show before closing
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui lokasi: $e');
    }
  }
}
