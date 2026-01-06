import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final isLoading = false.obs;

  // Toggle password visibility
  final isPasswordHidden = true.obs;
  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  // Toggle confirm password visibility
  final isConfirmPasswordHidden = true.obs;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      await _apiService.login(username, password);
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String username,
    String password,
    String rePassword,
  ) async {
    isLoading.value = true;
    try {
      final data = {
        'username': username,
        'password': password,
        're_password': rePassword,
      };

      await _apiService.registerTailor(data);
      Get.snackbar('Sukses', 'Registrasi berhasil. Silakan login.');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Registrasi Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
