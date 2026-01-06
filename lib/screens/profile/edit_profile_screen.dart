import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  late TextEditingController _shopNameController;
  late TextEditingController _bioController;

  File? _avatarFile;
  File? _shopImageFile;

  @override
  void initState() {
    super.initState();
    final user = controller.user.value;
    _shopNameController = TextEditingController(text: user?.shopName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await controller.pickImage();
    if (file != null) {
      setState(() {
        _avatarFile = file;
      });
    }
  }

  Future<void> _pickShopImage() async {
    final file = await controller.pickImage();
    if (file != null) {
      setState(() {
        _shopImageFile = file;
      });
    }
  }

  void _save() {
    controller.updateProfile(
      shopName: _shopNameController.text.trim(),
      bio: _bioController.text.trim(),
      avatarFile: _avatarFile,
      shopImageFile: _shopImageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Re-access user in build to ensure non-null usage if needed, though initState handles initial text
    final user = controller.user.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _avatarFile != null
                          ? FileImage(_avatarFile!)
                          : (user?.avatar != null && user!.avatar!.isNotEmpty)
                          ? NetworkImage(user.avatar!) as ImageProvider
                          : null,
                      child:
                          (_avatarFile == null &&
                              (user?.avatar == null || user!.avatar!.isEmpty))
                          ? Icon(
                              Iconsax.user,
                              size: 40,
                              color: Colors.grey[400],
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shop Image Section
              Text(
                'Foto Toko',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickShopImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _shopImageFile != null
                        ? DecorationImage(
                            image: FileImage(_shopImageFile!),
                            fit: BoxFit.cover,
                          )
                        : (user?.shopImage != null &&
                              user!.shopImage!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(user.shopImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      (_shopImageFile == null &&
                          (user?.shopImage == null || user!.shopImage!.isEmpty))
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.image,
                                size: 32,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Foto Toko',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              _buildTextField(
                label: 'Nama Toko',
                controller: _shopNameController,
                icon: Iconsax.shop,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Bio / Deskripsi',
                controller: _bioController,
                icon: Iconsax.note,
                maxLines: 3,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan Perubahan',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintText: 'Masukkan $label',
          ),
        ),
      ],
    );
  }
}
