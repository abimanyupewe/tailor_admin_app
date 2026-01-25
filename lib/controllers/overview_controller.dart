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
  final pendingOrders = 0.obs;
  final recentOrders = <dynamic>[].obs;
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
      List allOrders = [];
      String? nextUrl;

      // Initial fetch
      var response = await _apiService.getOrders();

      if (response is Map && response.containsKey('results')) {
        allOrders.addAll(response['results']);
        nextUrl = response['next'];

        if (response.containsKey('count')) {
          totalOrders.value = response['count'];
        }

        // Loop to fetch remaining pages for accurate Revenue/Active calc
        while (nextUrl != null) {
          try {
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

      if (allOrders.isNotEmpty) {
        if (totalOrders.value == 0) totalOrders.value = allOrders.length;

        double tRevenue = 0.0;
        int tActive = 0;
        int tPending = 0;

        // Reset lists
        recentOrders.clear();

        // 1. Sort by date (descending) just in case
        // Assuming 'created_at' exists, otherwise rely on API order
        // allOrders.sort((a, b) => b['created_at'].compareTo(a['created_at']));
        // (API usually returns sorted, skip explicit sort for performance unless needed)

        // 2. Get Recent Orders (Top 3)
        // Check if list is not empty before taking
        final recentCount = allOrders.length > 3 ? 3 : allOrders.length;
        recentOrders.addAll(allOrders.take(recentCount));

        // 3. Calculate Stats
        for (var item in allOrders) {
          String status = (item['status'] ?? '').toString().toUpperCase();
          double price =
              double.tryParse((item['total_price'] ?? '0').toString()) ?? 0.0;

          if (status == 'PENDING' ||
              status == 'ACCEPTED' ||
              status == 'IN_PROGRESS') {
            tActive++;
          }

          if (status == 'PENDING') {
            tPending++;
          }

          if (status == 'COMPLETED') {
            tRevenue += price;
          }
        }

        totalRevenue.value = tRevenue;
        activeOrders.value = tActive;
        pendingOrders.value = tPending;
      } else {
        totalOrders.value = 0;
        totalRevenue.value = 0.0;
        activeOrders.value = 0;
        pendingOrders.value = 0;
        recentOrders.clear();
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
        // Handle Username extraction
        if (profile.containsKey('user') && profile['user'] is Map) {
          username.value = profile['user']['username'] ?? '';
        } else if (profile.containsKey('username')) {
          username.value = profile['username'];
        }

        // Try to get rating from profile first
        double fetchedRating = 0.0;
        if (profile.containsKey('rating')) {
          fetchedRating = double.tryParse(profile['rating'].toString()) ?? 0.0;
        }

        // If 0, try fetching reviews to calculate it
        if (fetchedRating == 0.0) {
          int userId = profile['id'] ?? 0;
          if (userId > 0) {
            try {
              final reviewsResponse = await _apiService.getReviews(
                userId.toString(),
              );
              if (reviewsResponse is List) {
                if (reviewsResponse.isNotEmpty) {
                  double total = 0;
                  for (var r in reviewsResponse) {
                    total +=
                        double.tryParse((r['rating'] ?? 0).toString()) ?? 0.0;
                  }
                  fetchedRating = total / reviewsResponse.length;
                }
              } else if (reviewsResponse is Map &&
                  reviewsResponse.containsKey('results')) {
                // Handle pagination format
                List results = reviewsResponse['results'];
                if (results.isNotEmpty) {
                  double total = 0;
                  for (var r in results) {
                    total +=
                        double.tryParse((r['rating'] ?? 0).toString()) ?? 0.0;
                  }
                  fetchedRating = total / results.length;
                }
              }
            } catch (e) {
              print('Error fetching reviews for rating: $e');
            }
          }
        }

        rating.value = fetchedRating;
      }
    } catch (_) {}
  }

  void updateRange(int days) {
    selectedRange.value = days;
    fetchSummary();
  }
}
