import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/user_model.dart';

class UserController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final users = <UserModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getUsers();
      if (response is List) {
        users.value = response.map((e) => UserModel.fromJson(e)).toList();
      } else if (response is Map && response.containsKey('results')) {
        // Handle pagination if needed, for now just take results
        final List results = response['results'];
        users.value = results.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
