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
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
