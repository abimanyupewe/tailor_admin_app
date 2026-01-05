import 'package:get/get.dart';
import 'package:tailor_admin_app/screens/splash_screen.dart';
import 'package:tailor_admin_app/screens/auth/login_screen.dart';
import 'package:tailor_admin_app/screens/dashboard/dashboard_layout.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: dashboard, page: () => const DashboardLayout()),
  ];
}
