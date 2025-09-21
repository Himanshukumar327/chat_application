import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  String get currentUserId => _auth.currentUser!.uid;

  /// Unique chatId for two users
  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? "${uid1}_$uid2" : "${uid2}_$uid1";
  }

  /// Load messages in real-time
  void loadMessages(String receiverId) {
    final chatId = getChatId(currentUserId, receiverId);

    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Send message (text or image) and update chat overview
  Future<void> sendMessage({
    required String receiverId,
    String? text,
    String? imageUrl,
    Map<String, dynamic>? repliedTo,
  }) async {
    final chatId = getChatId(currentUserId, receiverId);

    final message = {
      "text": text,
      "imageUrl": imageUrl,
      "senderId": currentUserId,
      "receiverId": receiverId,
      "timestamp": FieldValue.serverTimestamp(),
      "repliedTo": repliedTo,
    };

    // ✅ 1. Message add करो
    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(message);

    // ✅ 2. दोनों users का data उठाओ
    final currentUserDoc =
    await _firestore.collection("users").doc(currentUserId).get();
    final receiverDoc =
    await _firestore.collection("users").doc(receiverId).get();

    final currentUserData = currentUserDoc.data() ?? {};
    final receiverData = receiverDoc.data() ?? {};

    // ✅ 3. chats/{chatId} में overview update करो
    await _firestore.collection("chats").doc(chatId).set({
      "chatId": chatId,
      "users": [currentUserId, receiverId],
      "lastMessage": text ?? "📷 Image",
      "lastMessageTime": FieldValue.serverTimestamp(),
      "userDetails": {
        currentUserId: {
          "name": currentUserData["fullName"] ?? "You",
          "imageUrl": currentUserData["imageUrl"] ??
              "https://ui-avatars.com/api/?name=Y",
        },
        receiverId: {
          "name": receiverData["fullName"] ?? "User",
          "imageUrl": receiverData["imageUrl"] ??
              "https://ui-avatars.com/api/?name=U",
        }
      }
    }, SetOptions(merge: true));
  }




  /// Upload image to Firebase Storage
  Future<String?> uploadImage(XFile image) async {
    try {
      final ref = _storage
          .ref()
          .child("chat_images")
          .child("${DateTime.now().millisecondsSinceEpoch}_${image.name}");
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }

  /// Send multiple images
  Future<void> sendImages({
    required String receiverId,
    required List<XFile> images,
    Map<String, dynamic>? repliedTo,
  }) async {
    for (var img in images) {
      final url = await uploadImage(img);
      if (url != null) {
        await sendMessage(
          receiverId: receiverId,
          imageUrl: url,
          repliedTo: repliedTo,
        );
      }
    }
  }



  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> callHistory = <Map<String, dynamic>>[].obs;

  // String get currentUserId => _auth.currentUser!.uid;

  void saveCallHistory(String receiverId, bool isVideo) async {
    final callId = "call_${Random().nextInt(999999)}";
    final data = {
      "callId": callId,
      "callerId": currentUserId,
      "receiverId": receiverId,
      "isVideo": isVideo,
      "timestamp": FieldValue.serverTimestamp(),
    };
    await _firestore.collection("calls").doc(callId).set(data);
    callHistory.add(data);
  }

  void loadCallHistory() {
    _firestore
        .collection("calls")
        .where("callerId", isEqualTo: currentUserId)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      callHistory.value =
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
