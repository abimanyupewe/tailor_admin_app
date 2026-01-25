import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:tailor_admin_app/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AuthController(),
    ); // Ensure auth controller is put
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.scissor,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Sign in to manage your tailor shop",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Username
                  Text(
                    "Username",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(
                        Iconsax.user,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (val) =>
                        (val ?? '').isEmpty ? 'Username required' : null,
                  ),
                  const SizedBox(height: 24),

                  // Password
                  Text(
                    "Password",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(
                          Iconsax.lock,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                            color: Colors.grey[500],
                            size: 20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (val) =>
                          (val ?? '').isEmpty ? 'Password required' : null,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56, // Taller button for full page feel
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.login(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Sign In",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signup'),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
