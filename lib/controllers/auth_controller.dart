import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final isLoading = false.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      await _apiService.login(username, password);
      // Determine navigation based on success
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
