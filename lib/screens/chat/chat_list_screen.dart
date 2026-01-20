import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_admin_app/controllers/chat_controller.dart';
import 'package:tailor_admin_app/data/api_service.dart';
import 'package:tailor_admin_app/screens/chat/chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'Pesan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.message, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada percakapan',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRooms(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.rooms.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final room = controller.rooms[index];
              return ListTile(
                onTap: () {
                  Get.to(() => ChatDetailScreen(room: room));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  backgroundImage: room.userAvatar != null
                      ? NetworkImage(
                          Get.find<ApiService>().getImageUrl(room.userAvatar),
                        )
                      : null,
                  child: room.userAvatar == null
                      ? Text(
                          room.userName.isNotEmpty
                              ? room.userName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.blue),
                        )
                      : null,
                ),
                title: Text(
                  room.userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  room.lastMessage ?? 'No messages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                trailing: Text(
                  room.lastMessageTime.length > 5 &&
                          room.lastMessageTime.contains('T')
                      ? room.lastMessageTime.split('T').last.substring(0, 5)
                      : room.lastMessageTime,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
