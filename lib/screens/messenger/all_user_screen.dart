import 'package:chat_app/screens/widget/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widget/custom_image.dart';
import '../widget/custom_text.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {

  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(
        backgroundColor: Colors.white,
        title: "All Users",
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Users Found"));
          }

          /// 🔹 अब current user को भी दिखाएंगे
          final users = snapshot.data!.docs.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final fullName = user["fullName"] ?? "No Name";
              final email = user["email"] ?? "";
              final imageUrl = user["imageUrl"] ??
                  "https://ui-avatars.com/api/?name=${fullName[0]}";

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  leading: ClipOval(
                    child: CustomCachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title:   Expanded(
                    child: CustomText.text(
                      text: fullName,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: CustomText.text(text:
                    email,
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
                          receiverId: user.id,
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
}
