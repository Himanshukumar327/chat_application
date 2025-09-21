// import 'package:chat_app/screens/call_history/call_page.dart';
import 'package:chat_app/screens/call_history/video_call.dart';
import 'package:chat_app/screens/widget/app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../contoroller/chat_controller.dart';
import '../call_history/call_screen.dart';
import '../widget/custom_image.dart';
import 'chat_bubble_screen.dart';
import 'chat_inputtext_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController chatController = Get.put(ChatController());
  Message? _repliedToMessage;

  @override
  void initState() {
    super.initState();
    chatController.loadMessages(widget.receiverId);
  }

  void _sendMessage(String text, List<XFile> images) async {
    if (text.isNotEmpty) {
      await chatController.sendMessage(
        receiverId: widget.receiverId,
        text: text,
        repliedTo: _repliedToMessage != null
            ? {
          "text": _repliedToMessage!.text,
          "imageUrl": _repliedToMessage!.imagePath,
          "senderId": _repliedToMessage!.isSent
              ? chatController.currentUserId
              : widget.receiverId,
        }
            : null,
      );
    }

    if (images.isNotEmpty) {
      await chatController.sendImages(
        receiverId: widget.receiverId,
        images: images,
        repliedTo: _repliedToMessage != null
            ? {
          "text": _repliedToMessage!.text,
          "imageUrl": _repliedToMessage!.imagePath,
          "senderId": _repliedToMessage!.isSent
              ? chatController.currentUserId
              : widget.receiverId,
        }
            : null,
      );
    }

    setState(() => _repliedToMessage = null);
  }

  void _onReply(Message message) {
    setState(() => _repliedToMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: ClipOval(
                child: CustomCachedNetworkImage(
                  imageUrl: widget.receiverImage,
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Text(widget.receiverName,overflow: TextOverflow.ellipsis,)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Get.to(() => AudioCallPage(
                receiverId: widget.receiverId,
                // isVideo: false,
                receiverName: widget.receiverName,
                // receiverImage: widget.receiverImage,
                // callerName: "Demo", callerImage: 'https://plus.unsplash.com/premium_photo-1757392183411-05b939d37bf5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw5fHx8ZW58MHx8fHx8',
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              Get.to(() => VideoCallPage(
                receiverId: widget.receiverId,
                // isVideo: true,
                receiverName: widget.receiverName,
                // receiverImage: widget.receiverImage,
                // callerName: "Demo",
                // callerImage: 'https://plus.unsplash.com/premium_photo-1757392183411-05b939d37bf5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw5fHx8ZW58MHx8fHx8',
              ));
            },
          ),

        ],
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: Image.asset("assets/images/chatbg.png",fit: BoxFit.cover,)),
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  final messages = chatController.messages;
                  if (messages.isEmpty) return const Center(child: Text("No messages yet"));
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i];
                      final messageObj = Message(
                        text: msg["text"],
                        imagePath: msg["imageUrl"],
                        isSent: msg["senderId"] == chatController.currentUserId,
                        timestamp: (msg["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
                        senderLabel: msg["senderId"] == chatController.currentUserId
                            ? "You"
                            : widget.receiverName,
                        repliedTo: msg["repliedTo"] != null
                            ? Message(
                          text: msg["repliedTo"]["text"],
                          imagePath: msg["repliedTo"]["imageUrl"],
                          isSent: msg["repliedTo"]["senderId"] == chatController.currentUserId,
                          timestamp: DateTime.now(),
                          senderLabel: msg["repliedTo"]["senderId"] == chatController.currentUserId
                              ? "You"
                              : widget.receiverName,
                        )
                            : null,
                      );
                      return ChatBubble(message: messageObj, onReply: () => _onReply(messageObj));
                    },
                  );
                }),
              ),
              if (_repliedToMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(child: Text("Replying to: ${_repliedToMessage!.text ?? '[Image]'}")),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _repliedToMessage = null)),
                    ],
                  ),
                ),
              ChatInputTextField(onSend: _sendMessage),
            ],
          )
        ],
      ),
    );
  }
}

class Message {
  final String? text;
  final String? imagePath;
  final bool isSent;
  final DateTime timestamp;
  final String? senderLabel;
  final Message? repliedTo;

  Message({
    this.text,
    this.imagePath,
    required this.isSent,
    required this.timestamp,
    this.senderLabel,
    this.repliedTo,
  });
}
