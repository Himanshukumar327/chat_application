import 'package:chat_app/contoroller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'call_controller.dart';
 
class CallHistoryScreen extends StatelessWidget {
  final ChatController callController = Get.put(ChatController());

  CallHistoryScreen({super.key}) {
    callController.loadCallHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Call History")),
      body: Obx(() {
        final calls = callController.callHistory;
        if (calls.isEmpty) return const Center(child: Text("No calls yet"));

        return ListView.builder(
          itemCount: calls.length,
          itemBuilder: (context, index) {
            final call = calls[index];
            return ListTile(
              leading: Icon(call["isVideo"] ? Icons.videocam : Icons.call),
              title: Text("To: ${call["receiverId"]}"),
              subtitle: Text(call["timestamp"]?.toDate().toString() ?? ""),
            );
          },
        );
      }),
    );
  }
}
