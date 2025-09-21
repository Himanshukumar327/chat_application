import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contoroller/call_controller.dart';
// import 'call_controller.dart';

class AudioCallPage extends StatelessWidget {
  final String receiverId;
  final String receiverName;

  AudioCallPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  final CallController callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    callController.initCall(receiverId: receiverId,isVideo: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote user
          // callController.initCall(receiverId: receiverId, isVideo: false);

        Obx(() => Positioned.fill(child: callController.renderRemoteUser())),

          // Local mic preview
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

          // End call button
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
