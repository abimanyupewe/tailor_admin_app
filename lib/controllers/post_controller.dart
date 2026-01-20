import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/post_model.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final posts = <PostModel>[].obs;
  final isLoading = true.obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getPosts();
      if (response is List) {
        posts.value = response.map((e) => PostModel.fromJson(e)).toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        posts.value = results.map((e) => PostModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat portofolio: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPost(String caption, File? imageFile) async {
    isUploading.value = true;
    try {
      if (imageFile == null) {
        // If no image, try basic addPost or warn
        // For now let's allow text only if backend supports it, but "Post" usually implies image
        // Let's assume we use addPostMultipart with just caption if no image
        await _apiService.addPostMultipart(caption: caption, imageFile: null);
      } else {
        await _apiService.addPostMultipart(
          caption: caption,
          imageFile: imageFile,
        );
      }

      Get.snackbar(
        'Sukses',
        'Postingan berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      fetchPosts();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah postingan: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
      Get.snackbar('Sukses', 'Postingan berhasil dihapus');
      fetchPosts();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus postingan: $e');
    }
  }

  // Helper for image picker
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
