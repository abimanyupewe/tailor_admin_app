import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetxService {
  late final String baseUrl;
  String? _token;

  bool get isAuthenticated => _token != null;

  @override
  void onInit() {
    super.onInit();
    baseUrl = dotenv.env['URL_API'] ?? 'http://127.0.0.1:8000';
    _loadToken();
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) {
      if (Platform.isAndroid) {
        return path
            .replaceAll('localhost', '10.0.2.2')
            .replaceAll('127.0.0.1', '10.0.2.2');
      }
      return path;
    }
    return '$baseUrl$path';
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Token $_token';
    }
    return headers;
  }

  Future<dynamic> fetchByUrl(String url) async {
    // Helper to fetch pagination next links directly
    final response = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(response);
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // DEBUG: Print response for troubleshooting
      print('API Response [${response.request?.url}]: ${response.body}');
      return json.decode(response.body);
    } else {
      String errorMessage = 'Error ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map) {
          if (errorBody.containsKey('non_field_errors')) {
            errorMessage = (errorBody['non_field_errors'] as List).join('\n');
          } else if (errorBody.containsKey('detail')) {
            errorMessage = errorBody['detail'];
          } else if (errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          } else {
            // Join all errors with their keys
            errorMessage = errorBody.entries
                .map((e) => '${e.key}: ${e.value}')
                .join('\n');
          }
        } else {
          errorMessage = errorBody.toString();
        }
      } catch (_) {
        // If not JSON (e.g. HTML 404), truncate it
        errorMessage = response.body.length > 100
            ? 'Server Error (${response.statusCode}): ${response.body.substring(0, 100)}...'
            : 'Server Error (${response.statusCode}): ${response.body}';
      }
      throw Exception(errorMessage);
    }
  }

  // --- Authentication ---
  Future<dynamic> registerTailor(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/register-tailor/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'username': username, 'password': password}),
    );
    final data = await _handleResponse(response);

    // Check for various token keys
    String? token;
    if (data['access'] != null) {
      token = data['access'];
    } else if (data['token'] != null) {
      token = data['token'];
    } else if (data['key'] != null) {
      token = data['key'];
    }

    if (token != null) {
      await setToken(token);
    }
    return data;
  }

  // --- User Profile ---
  Future<dynamic> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/profile/me/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/profile/me/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> updateProfileMultipart({
    required Map<String, String> data,
    File? avatarFile,
    File? shopImageFile,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/api/users/profile/me/'),
    );

    request.headers.addAll(_headers);
    request.fields.addAll(data);

    if (avatarFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatarFile.path),
      );
    }

    // For shop image (Tailor profile)
    // The field name depends on backend. Usually 'shop_image' based on key in json
    if (shopImageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('shop_image', shopImageFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<dynamic> getUsers({String? role}) async {
    String query = '';
    if (role != null) {
      query = '?role=$role';
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/list/$query'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Tailor Features ---
  Future<dynamic> getMyLocation() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/manage/location/my_location/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> setMyLocation(double lat, double lon, String address) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tailor/manage/location/my_location/'),
      headers: _headers,
      body: json.encode({
        'latitude': lat,
        'longitude': lon,
        'address': address,
      }),
    );
    return _handleResponse(response);
  }

  Future<dynamic> getMyServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/manage/services/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> addService(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tailor/manage/services/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> addPost(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tailor/manage/posts/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> addPostMultipart({
    required String caption,
    File? imageFile,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/tailor/manage/posts/'),
    );

    request.headers.addAll(_headers);
    request.fields['caption'] = caption;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  // --- Search & Homepage ---
  Future<List<dynamic>> getTailors({
    double? lat,
    double? lon,
    double? radius,
    String? search,
  }) async {
    String query = '?';
    if (lat != null && lon != null) query += 'lat=$lat&lon=$lon&';
    if (radius != null) query += 'radius=$radius&';
    if (search != null) query += 'search=$search&';

    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/list/$query'),
      headers: _headers,
    );
    final data = await _handleResponse(response);
    if (data is Map && data.containsKey('results')) {
      return List<dynamic>.from(data['results']);
    }
    return List<dynamic>.from(data);
  }

  Future<dynamic> getTailorDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/list/$id/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Orders ---
  Future<dynamic> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> getOrderById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders/$id/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/orders/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> updateOrderStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/orders/$id/status/'),
      headers: _headers,
      body: json.encode({'status': status}),
    );
    return _handleResponse(response);
  }

  // --- Maintenance ---
  Future<dynamic> cleanupPendingOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders/cleanup/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Reviews ---
  Future<dynamic> getReviews(String tailorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/reviews/?tailor_id=$tailorId'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> createReview(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/reviews/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // --- Dashboard ---
  Future<dynamic> getDashboardSummary({int range = 7}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/dashboard/summary/?range=$range'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // --- Manage Services ---
  Future<dynamic> updateService(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/tailor/manage/services/$id/'),
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> deleteService(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tailor/manage/services/$id/'),
      headers: _headers,
    );
    if (response.statusCode == 204) return true;
    return _handleResponse(response);
  }

  // --- Manage Portfolio (Posts) ---
  Future<dynamic> getPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tailor/manage/posts/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tailor/manage/posts/$id/'),
      headers: _headers,
    );
    if (response.statusCode == 204) return true;
    return _handleResponse(response);
  }

  // --- Chat ---
  Future<dynamic> startChat(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/start/$userId/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> getChatRooms() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/rooms/'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> getChatMessages(int roomId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/chat/rooms/$roomId/messages/?ordering=-created_at',
      ),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> sendMessage(int roomId, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/rooms/$roomId/messages/'),
      headers: _headers,
      body: json.encode({'text': text}),
    );
    return _handleResponse(response);
  }
}
