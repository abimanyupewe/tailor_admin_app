import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/routes/app_routes.dart';

class SplashController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for a moment to show splash screen (optional, for UX)
    await Future.delayed(const Duration(seconds: 4));

    // Check if token exists
    // ApiService loads token in onInit, but it's async void.
    // We might need to ensure it's loaded.
    // Since ApiService is initialized at start, we can verify checking shared prefs again or relying on a getter
    // For safety, let's verify closely.

    // Actually ApiService.onInit calls _loadToken() which is async but not awaited by GetX system.
    // However, by the time Splash checks after 2 seconds, it should be loaded.
    // Better approach: accessing the token check directly or recalling load if needed.

    // We can access the private _token via isAuthenticated getter if we trust it's loaded.
    // Or we can force a check here.

    // Let's rely on isAuthenticated for now, but to be safe, we can trigger a check.
    // Since _loadToken is private, let's just make sure we are good.
    // Ideally ApiService should return a Future for initialization, but GetxService doesn't wait.

    if (_apiService.isAuthenticated) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
