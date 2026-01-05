import 'package:get/get.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/models/chat_model.dart';
import 'package:tailor_admin_app/models/user_model.dart'; // import if needed for my id

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final rooms = <ChatRoom>[].obs;
  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;

  int? currentUserId; // To determine isMe

  @override
  void onInit() {
    super.onInit();
    _fetchMyId();
    fetchRooms();
  }

  Future<void> _fetchMyId() async {
    try {
      final profile = await _apiService.getProfile();
      currentUserId = profile['id'];
    } catch (_) {}
  }

  Future<void> fetchRooms() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getChatRooms();
      if (response is List) {
        rooms.value = response.map((e) => ChatRoom.fromJson(e)).toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        rooms.value = results.map((e) => ChatRoom.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat chat room: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessages(int roomId) async {
    // Don't set full loading if just refreshing, but initial yes
    // isLoading.value = true;
    try {
      final response = await _apiService.getChatMessages(roomId);
      if (response is List) {
        messages.value = response
            .map((e) => ChatMessage.fromJson(e, currentUserId ?? 0))
            .toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        messages.value = results
            .map((e) => ChatMessage.fromJson(e, currentUserId ?? 0))
            .toList();
      }
      // Reverse messages if API returns newest first, depends on UI expectations
      // Usually chat UI builds from bottom.
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pesan: $e');
    }
  }

  Future<void> sendMessage(int roomId, String text) async {
    if (text.trim().isEmpty) return;
    isSending.value = true;
    try {
      await _apiService.sendMessage(roomId, text);
      fetchMessages(roomId); // Refresh messages
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan: $e');
    } finally {
      isSending.value = false;
    }
  }
}
