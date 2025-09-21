import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class CallController extends GetxController {
  final ChatController chatController = Get.find<ChatController>();

  late final RtcEngine engine;
  static const String appId = "35cca596bc3143438adb86dc749e004c";
  final String token =
      "007eJxTYCjjnFq9menRtKxO7l6b6axFXFXbnJXub121wfHjr31feVUUGIxNk5MTTS3NkpKNDU2MTYwtElOSLMxSks1NLFMNDEySm1cfy2gIZGTwT3vPysgAgSA+I0M6AwMAxf4eQg==";
  late String channelName;
  var remoteUid = Rxn<int>();
  var joined = false.obs;
  late String receiverId;
  bool isVideoCall = false;

  void initCall({
    required String receiverId,
    required bool isVideo,
  }) {
    this.receiverId = receiverId;
    this.isVideoCall = isVideo;
    channelName = "chat_${DateTime.now().millisecondsSinceEpoch}";
    _initAgora();
    _saveCallToHistory();
  }

  Future<void> _initAgora() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    if (isVideoCall) {
      await engine.enableVideo();
    } else {
      await engine.enableAudio();
    }

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          joined.value = true;
          print("Joined channel: ${connection.channelId}, uid: ${connection.localUid}");
        },
        onUserJoined: (connection, uid, elapsed) {
          remoteUid.value = uid;
          print("Remote user joined: $uid");
        },
        onUserOffline: (connection, uid, reason) {
          remoteUid.value = null;
          print("Remote user left: $uid");
        },
      ),
    );

    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _saveCallToHistory() {
    chatController.saveCallHistory(receiverId, isVideoCall);
  }

  void endCall() {
    engine.leaveChannel();
    engine.release();
  }

  Widget renderLocalPreview() {
    if (!joined.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isVideoCall) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(child: Icon(Icons.mic, size: 50, color: Colors.white));
    }
  }

  Widget renderRemoteUser() {
    final uid = remoteUid.value;
    if (uid != null) {
      if (isVideoCall) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: engine,
            canvas: VideoCanvas(uid: uid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Center(
          child: Icon(Icons.mic_none, size: 80, color: Colors.white),
        );
      }
    } else {
      return const Center(
        child: Text(
          "Waiting for user...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  @override
  void onClose() {
    endCall();
    super.onClose();
  }
}
