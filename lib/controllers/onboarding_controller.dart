import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_admin_app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    Get.offAllNamed(AppRoutes.login);
  }
}
