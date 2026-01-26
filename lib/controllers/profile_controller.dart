import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_admin_app/routes/app_routes.dart';

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
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    File? avatarFile,
    File? shopImageFile,
  }) async {
    try {
      isLoading.value = true;

      Map<String, String> data = {};
      if (shopName != null) data['shop_name'] = shopName;
      if (bio != null) data['bio'] = bio;
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (email != null) data['email'] = email;

      await _apiService.updateProfileMultipart(
        data: data,
        avatarFile: avatarFile,
        shopImageFile: shopImageFile,
      );

      fetchProfile(); // Refresh data

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Data profil berhasil diperbarui.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        buttonColor: const Color(0xFF4F46E5),
        onConfirm: () {
          Get.back(); // Close Dialog
          Get.back(); // Close Screen
        },
        barrierDismissible: false,
      );
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
    try {
      await _apiService.logout();
    } catch (e) {
      print('Logout Error: $e');
    } finally {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
