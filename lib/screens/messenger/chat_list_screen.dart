import 'package:chat_app/screens/widget/app_bar.dart'; // Tera app_bar import
import 'package:chat_app/screens/widget/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../auth/login_screen.dart';
import '../widget/custom_text.dart';
import 'all_user_screen.dart';
import 'chat_screen.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    bool? isSelected = false;
    return Scaffold(
      backgroundColor:  Color(0xFFF5F6FA),
      appBar: NormalAppBar(
        backgroundColor: Colors.white,
        title: "Chats",
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut(); // Firebase logout
                // Navigate to login screen after logout
                Get.offAll(() =>  LoginScreen());
              } catch (e) {
                Get.snackbar(
                  "Error",
                  "Failed to logout: $e",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {

          Get.to(
                () => ChatListScreen(),
            transition: Transition.rightToLeftWithFade, // Animation style
            duration: const Duration(milliseconds: 400), // Speed
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("users", arrayContains: currentUserId)
            // .orderBy("orderBylastMessageTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No chats yet. Start a new one!"),
                ],
              ),
            );
          }

          final chats = snapshot.data!.docs.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;
              final users = chat["users"] as List<dynamic>;
              final receiverId = users[0] == currentUserId
                  ? users[1]
                  : users[0];
              final userDetails =
                  chat["userDetails"] as Map<String, dynamic>? ?? {};
              final receiverData =
                  userDetails[receiverId] as Map<String, dynamic>? ?? {};
              final fullName = receiverData["name"] ?? "No Name";
              final imageUrl =
                  receiverData["imageUrl"] ??
                  "https://ui-avatars.com/api/?name=${fullName[0]}";
              final lastMessage = chat["lastMessage"] ?? "No message";
              final lastTime = (chat["lastMessageTime"] as Timestamp?)
                  ?.toDate();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xffD9F2E6) : Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  leading: ClipOval(
                    child: CustomCachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText.text(
                          text: fullName,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastTime != null)
                        CustomText.text(
                          text: _formatTime(context, lastTime),
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                    ],
                  ),
                  subtitle: CustomText.text(
                    text: lastMessage.length > 35
                        ? "${lastMessage.substring(0, 35)}..."
                        : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          receiverId: receiverId,
                          receiverName: fullName,
                          receiverImage: imageUrl,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return TimeOfDay.fromDateTime(time).format(context);
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else {
      return "${time.day}/${time.month}";
    }
  }
}
