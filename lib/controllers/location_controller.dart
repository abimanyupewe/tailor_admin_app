import 'package:get/get.dart';
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
        latitude.value =
            double.tryParse(response['latitude'].toString()) ?? 0.0;
        longitude.value =
            double.tryParse(response['longitude'].toString()) ?? 0.0;
        address.value = response['address'] ?? '';
      }
    } catch (e) {
      // Ignore 404 if not set
      // Get.snackbar('Info', 'Belum ada lokasi diset');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLocation(double lat, double lon, String addr) async {
    try {
      await _apiService.setMyLocation(lat, lon, addr);
      latitude.value = lat;
      longitude.value = lon;
      address.value = addr;
      Get.snackbar('Sukses', 'Lokasi berhasil diperbarui');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui lokasi: $e');
    }
  }
}
