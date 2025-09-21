import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoroller/call_controller.dart';

class VideoCallPage extends StatelessWidget {
  final String receiverId;
  final String receiverName;

  VideoCallPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  final CallController callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    callController.initCall(receiverId: receiverId, isVideo: true);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() => Positioned.fill(child: callController.renderRemoteUser())),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 120,
              height: 160,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Obx(() => callController.renderLocalPreview()),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "endCall",
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                  onPressed: () {
                    callController.endCall();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
