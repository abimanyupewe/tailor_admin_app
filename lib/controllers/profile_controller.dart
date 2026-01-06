import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/user_model.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final user = Rxn<UserModel>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getProfile();
      user.value = UserModel.fromJson(response);
    } catch (e) {
      print('Profile Controller Error: $e');
      Get.snackbar('Error', 'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    Get.offAllNamed('/login');
  }
}
