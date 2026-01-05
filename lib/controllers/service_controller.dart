import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final services = <ServiceModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getMyServices();
      if (response is List) {
        services.value = response.map((e) => ServiceModel.fromJson(e)).toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        services.value = results.map((e) => ServiceModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat layanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addService(Map<String, dynamic> data) async {
    try {
      await _apiService.addService(data);
      Get.snackbar('Sukses', 'Layanan berhasil ditambahkan');
      fetchServices();
      Get.back(); // Close dialog/screen
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah layanan: $e');
    }
  }

  Future<void> updateService(int id, Map<String, dynamic> data) async {
    try {
      await _apiService.updateService(id, data);
      Get.snackbar('Sukses', 'Layanan berhasil diperbarui');
      fetchServices();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui layanan: $e');
    }
  }

  Future<void> deleteService(int id) async {
    try {
      await _apiService.deleteService(id);
      Get.snackbar('Sukses', 'Layanan berhasil dihapus');
      fetchServices();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus layanan: $e');
    }
  }
}
