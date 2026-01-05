import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/dashboard_controller.dart';
import 'package:tailor_admin_app/screens/dashboard/overview_page.dart';
import 'package:tailor_admin_app/screens/orders/order_list_screen.dart';
import 'package:tailor_admin_app/screens/chat/chat_list_screen.dart';
import 'package:tailor_admin_app/screens/profile/profile_screen.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller if not already present (Bindings would be better but this works for simple cases)
    final controller = Get.put(DashboardController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: const [
            OverviewPage(),
            OrderListScreen(),
            ChatListScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.tabIndex.value,
          onDestinationSelected: controller.changeTabIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Overview'),
            NavigationDestination(icon: Icon(Iconsax.box), label: 'Orders'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'Chat'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
