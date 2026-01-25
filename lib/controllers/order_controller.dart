import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/order_model.dart';

class OrderController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> updateOrderStatus(int id, String status) async {
    try {
      await _apiService.updateOrderStatus(id.toString(), status);
      // Refresh list locally or via fetch
      final index = orders.indexWhere((o) => o.id == id);
      if (index != -1) {
        // Create new object with updating status to avoid full refresh flicker
        // Assuming OrderModel has copyWith or manual update. Model is simple class though.
        // Easiest is to refetch or manually update list if valid
        fetchOrders();
      }
      Get.snackbar('Sukses', 'Status pesanan berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: $e');
    }
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getOrders();
      if (response is List) {
        orders.value = response.map((e) => OrderModel.fromJson(e)).toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        orders.value = results.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pesanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  Future<void> fetchOrderDetail(int id) async {
    // Optional: set loading state specifically for detail if needed, or use main isLoading
    // For now, let's just fetch quietly or show dialog loader in UI
    try {
      final response = await _apiService.getOrderById(id);
      if (response is Map<String, dynamic>) {
        selectedOrder.value = OrderModel.fromJson(response);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail pesanan: $e');
    }
  }
}
