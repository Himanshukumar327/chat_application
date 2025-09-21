import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String callId;
  final String callerId;
  final String receiverId;
  final bool isVideo;
  final DateTime timestamp;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.isVideo,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "callId": callId,
      "callerId": callerId,
      "receiverId": receiverId,
      "isVideo": isVideo,
      "timestamp": timestamp,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map["callId"],
      callerId: map["callerId"],
      receiverId: map["receiverId"],
      isVideo: map["isVideo"],
      timestamp: (map["timestamp"] as Timestamp).toDate(),
    );
  }
}
