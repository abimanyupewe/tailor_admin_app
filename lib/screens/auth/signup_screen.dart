import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F51B5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Join as a Tailor Partner',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username
                  _buildLabel('Username'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: usernameController,
                    decoration: _inputDecoration(
                      'Enter username',
                      Iconsax.user,
                    ),
                    validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration:
                          _inputDecoration(
                            'Enter password',
                            Iconsax.lock,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                      validator: (v) =>
                          (v ?? '').length < 6 ? 'Min 6 chars' : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  _buildLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextFormField(
                      controller: confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration:
                          _inputDecoration(
                            'Confirm password',
                            Iconsax.lock,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordHidden.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                              ),
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                      validator: (v) {
                        if (v != passwordController.text)
                          return 'Password mismatch';
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
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
                          backgroundColor: const Color(0xFF3F51B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign Up',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF3F51B5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
