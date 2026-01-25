import 'package:get/get.dart';
import 'package:tailor_admin_app/screens/splash_screen.dart';
import 'package:tailor_admin_app/screens/auth/login_screen.dart';
import 'package:tailor_admin_app/screens/auth/signup_screen.dart';
import 'package:tailor_admin_app/screens/dashboard/dashboard_layout.dart';
import 'package:tailor_admin_app/screens/onboarding_screen.dart'; // Add import

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const onboarding = '/onboarding';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => const SignupScreen()),
    GetPage(name: dashboard, page: () => const DashboardLayout()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
  ];
}
