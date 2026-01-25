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
    _initData();
  }

  Future<void> _initData() async {
    await _fetchMyId();
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
        rooms.value = response
            .map((e) => ChatRoom.fromJson(e, currentUserId))
            .toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        rooms.value = results
            .map((e) => ChatRoom.fromJson(e, currentUserId))
            .toList();
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
      List<ChatMessage> fetched = [];
      if (response is List) {
        fetched = response
            .map((e) => ChatMessage.fromJson(e, currentUserId ?? 0))
            .toList();
      } else if (response is Map && response.containsKey('results')) {
        final List results = response['results'];
        fetched = results
            .map((e) => ChatMessage.fromJson(e, currentUserId ?? 0))
            .toList();
      }

      // Client-side sort: Oldest first (Ascending)
      fetched.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      messages.value = fetched;
      // Reverse messages if API returns newest first, depends on UI expectations
      // Usually chat UI builds from bottom.
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pesan: $e');
    }
  }

  Future<bool> sendMessage(int roomId, String text) async {
    if (text.trim().isEmpty) return false;
    isSending.value = true;
    try {
      print('DEBUG SEND: roomId=$roomId text=$text');
      await _apiService.sendMessage(roomId, text);
      print('DEBUG SEND SUCCESS');
      await fetchMessages(roomId); // Refresh messages
      return true;
    } catch (e) {
      print('DEBUG SEND ERROR: $e');
      Get.defaultDialog(
        title: 'Gagal Mengirim',
        middleText: 'Error: $e',
        textConfirm: 'OK',
        confirmTextColor: Get.theme.primaryColor,
        onConfirm: () => Get.back(),
      );
      return false;
    } finally {
      isSending.value = false;
    }
  }

  Future<void> startChat(int userId) async {
    try {
      await _apiService.startChat(userId);
      await fetchRooms();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memulai chat: $e');
    }
  }
}
