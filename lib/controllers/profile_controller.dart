import 'dart:io';
import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> updateProfile({
    String? shopName,
    String? bio,
    String? phoneNumber, // If available in future
    File? avatarFile,
    File? shopImageFile,
  }) async {
    try {
      isLoading.value = true;

      Map<String, String> data = {};
      if (shopName != null) data['shop_name'] = shopName;
      if (bio != null) data['bio'] = bio;
      // if (phoneNumber != null) data['phone_number'] = phoneNumber;

      await _apiService.updateProfileMultipart(
        data: data,
        avatarFile: avatarFile,
        shopImageFile: shopImageFile,
      );

      Get.snackbar('Sukses', 'Profil berhasil diperbarui');
      fetchProfile(); // Refresh data
      Get.back(); // Close edit screen
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> logout() async {
    await _apiService.logout();
    Get.offAllNamed('/login');
  }
}
