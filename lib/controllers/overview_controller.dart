import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';

class OverviewController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = true.obs;
  // Summary Data
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final totalViews =
      0.obs; // Example metric if available, otherwise just what API returns
  final activeOrders = 0.obs;

  // Range selection
  final selectedRange = 7.obs; // Default 7 days

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getDashboardSummary(
        range: selectedRange.value,
      );
      // Assuming response structure based on typical dashboard APIs
      // { "orders": 10, "revenue": 500000, "active_orders": 2, ... }
      if (response is Map) {
        totalOrders.value = response['total_orders'] ?? 0;
        // Handle revenue which might be int or double
        if (response['revenue'] != null) {
          totalRevenue.value =
              double.tryParse(response['revenue'].toString()) ?? 0.0;
        }
        activeOrders.value = response['active_orders'] ?? 0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat ringkasan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateRange(int days) {
    selectedRange.value = days;
    fetchSummary();
  }
}
