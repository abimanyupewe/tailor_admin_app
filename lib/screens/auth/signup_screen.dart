import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/constants/app_colors.dart';
import 'package:tailor_admin_app/controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
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
                        Iconsax.user_add,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Join as a Tailor Partner",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Username
                  _buildLabel("Username"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: usernameController,
                    decoration: _inputDecoration(
                      "Enter username",
                      Iconsax.user,
                    ),
                    validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  // Password
                  _buildLabel("Password"),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration:
                          _inputDecoration(
                            "Enter password",
                            Iconsax.lock,
                          ).copyWith(
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
                          ),
                      validator: (v) =>
                          (v ?? '').length < 6 ? 'Min 6 chars' : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password
                  _buildLabel("Confirm Password"),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration:
                          _inputDecoration(
                            "Confirm password",
                            Iconsax.lock,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordHidden.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                      validator: (v) {
                        if (v != passwordController.text) {
                          return 'Password mismatch';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.register(
                                    usernameController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
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
                                "Sign Up",
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
                        "Already have an account? ",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          "Sign In",
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.primary,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
