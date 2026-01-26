import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  File? _avatarFile;
  File? _shopImageFile;

  @override
  void initState() {
    super.initState();
    final user = controller.user.value;
    _shopNameController = TextEditingController(text: user?.shopName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _bioController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      avatarFile: _avatarFile,
      shopImageFile: _shopImageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.user.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photos Section
              _buildPhotoSection(user),
              const SizedBox(height: 32),

              // Form Sections
              _buildSectionHeader('Informasi Pribadi'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernTextField(
                            label: 'Nama Depan',
                            controller: _firstNameController,
                            icon: Iconsax.user,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernTextField(
                            label: 'Nama Belakang',
                            controller: _lastNameController,
                            icon: Iconsax.user,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Iconsax.sms,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      label: 'Nomor HP',
                      controller: _phoneController,
                      icon: Iconsax.call,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Informasi Toko'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildModernTextField(
                      label: 'Nama Toko',
                      controller: _shopNameController,
                      icon: Iconsax.shop,
                    ),
                    const SizedBox(height: 16),
                    _buildModernTextField(
                      label: 'Bio / Deskripsi',
                      controller: _bioController,
                      icon: Iconsax.note_text,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: AppColors.primary.withOpacity(0.4),
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
      ),
    );
  }

  Widget _buildPhotoSection(dynamic user) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAvatar,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!) as ImageProvider
                      : null,
                  child:
                      (_avatarFile == null &&
                          (user?.avatar == null || user!.avatar!.isEmpty))
                      ? const Icon(
                          Iconsax.user,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Iconsax.camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _pickShopImage,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              image: _shopImageFile != null
                  ? DecorationImage(
                      image: FileImage(_shopImageFile!),
                      fit: BoxFit.cover,
                    )
                  : (user?.shopImage != null && user!.shopImage!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(user.shopImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child:
                (_shopImageFile == null &&
                    (user?.shopImage == null || user!.shopImage!.isEmpty))
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.image,
                          size: 24,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Foto Cover Toko',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: const Center(
                      child: Icon(Iconsax.edit, color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(
              0xFF1E293B,
            ), // Darker for readability, or use Primary if requested? Let's use Dark.
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ), // Primary Color
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              hintText: 'Masukkan $label',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
