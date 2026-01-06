import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';

class OverviewController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = true.obs;
  // Summary Data
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final totalViews =
      0.obs; // Example metric if available, otherwise just what API returns
  final activeOrders = 0.obs;
  final rating = 0.0.obs;
  final username = ''.obs;

  // Range selection
  final selectedRange = 7.obs; // Default 7 days

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    _fetchRatingFromProfile();
  }

  Future<void> fetchSummary() async {
    isLoading.value = true;
    try {
      // Fetch actual orders list to calculate fields manually
      // Loop through pagination to get ALL orders for accurate stats
      List allOrders = [];
      String? nextUrl;

      // Initial fetch
      var response = await _apiService.getOrders();

      if (response is Map && response.containsKey('results')) {
        allOrders.addAll(response['results']);
        nextUrl = response['next'];

        // If "count" exists, we can use it for Total Orders directly
        if (response.containsKey('count')) {
          totalOrders.value = response['count'];
        }

        // Loop to fetch remaining pages for Revenue/Active calc
        while (nextUrl != null) {
          try {
            // Use helper to fetch by direct URL
            // Note: ApiService needs a helper or we manually call http?
            // Let's assume we added fetchByUrl or we hack it.
            // Since I added fetchByUrl a moment ago, let's use it.
            var nextResponse = await _apiService.fetchByUrl(nextUrl);
            if (nextResponse is Map && nextResponse.containsKey('results')) {
              allOrders.addAll(nextResponse['results']);
              nextUrl = nextResponse['next'];
            } else {
              nextUrl = null;
            }
          } catch (e) {
            print('Error fetching next page: $e');
            nextUrl = null;
          }
        }
      } else if (response is List) {
        allOrders = response;
        totalOrders.value = allOrders.length;
      }

      // Calculate Revenue & Active from ALL orders
      if (allOrders.isNotEmpty) {
        // If count was set from pagination, don't overwrite it with local list length unless necessary
        // Actually local list length is safer if we fetched all.
        if (totalOrders.value == 0) totalOrders.value = allOrders.length;

        double tRevenue = 0.0;
        int tActive = 0;

        for (var item in allOrders) {
          String status = (item['status'] ?? '').toString().toUpperCase();
          double price =
              double.tryParse((item['total_price'] ?? '0').toString()) ?? 0.0;

          // Active orders: Pending, Accepted, In_Progress
          if (status == 'PENDING' ||
              status == 'ACCEPTED' ||
              status == 'IN_PROGRESS') {
            tActive++;
          }

          // Revenue: Only 'COMPLETED' (Assumed Paid)
          if (status == 'COMPLETED') {
            tRevenue += price;
          }
        }

        totalRevenue.value = tRevenue;
        activeOrders.value = tActive;
      } else {
        // Reset if empty
        totalOrders.value = 0;
        totalRevenue.value = 0.0;
        activeOrders.value = 0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat statistik: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchRatingFromProfile() async {
    try {
      final profile = await _apiService.getProfile();
      if (profile is Map) {
        // Handle rating override from profile if exists
        if (profile.containsKey('rating')) {
          rating.value = double.tryParse(profile['rating'].toString()) ?? 0.0;
        } else if (profile['user'] != null &&
            profile['user'] is Map &&
            profile['user'].containsKey('rating')) {
          // Check inside user object just in case
          rating.value =
              double.tryParse(profile['user']['rating'].toString()) ?? 0.0;
        }

        // Handle Username extraction from nested user object
        if (profile.containsKey('user') && profile['user'] is Map) {
          username.value = profile['user']['username'] ?? '';
        } else if (profile.containsKey('username')) {
          username.value = profile['username'];
        }
      }
    } catch (_) {}
  }

  void updateRange(int days) {
    selectedRange.value = days;
    fetchSummary();
  }
}
