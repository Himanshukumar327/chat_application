

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../widget/custom_image.dart';
import '../widget/custom_text.dart';
import 'chat_screen.dart';




void screenNavigator(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}




class ChatBubble extends StatefulWidget {
  final Message message;
  final VoidCallback? onReply;
  final FocusNode? inputFocusNode;

  const ChatBubble({
    super.key,
    required this.message,
    this.onReply,
    this.inputFocusNode,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  double _dragDx = 0.0;
  bool _actionTriggered = false;

  // Tuning
  static const double _maxDrag = 100.0;
  static const double _triggerThreshold = 40.0;
  static const double _velocityTrigger = 250.0;

  void _triggerReply() {
    if (_actionTriggered) return;
    _actionTriggered = true;
    widget.onReply?.call();
    if (widget.inputFocusNode != null) {
      FocusScope.of(context).requestFocus(widget.inputFocusNode!);
    }
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _dragDx = 0.0);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _actionTriggered = false;
      });
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.delta.dx;
    if (delta <= 0 && _dragDx <= 0) return;
    setState(() {
      _dragDx = (_dragDx + delta).clamp(0.0, _maxDrag);
    });
    if (_dragDx >= _triggerThreshold && !_actionTriggered) {
      _triggerReply();
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final double velocityX = details.velocity.pixelsPerSecond.dx;
    if (!_actionTriggered && velocityX > _velocityTrigger) {
      _triggerReply();
    } else {
      setState(() => _dragDx = 0.0);
      _actionTriggered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;
    final isSent = msg.isSent;

    final double iconProgress = (_dragDx / _triggerThreshold).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), // compact spacing
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (_) {
          if (!_actionTriggered) setState(() => _dragDx = 0.0);
        },
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8,
              child: Opacity(
                opacity: iconProgress,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.reply, size: 18, color: Colors.black),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(_dragDx, 0),
              child: _buildBubbleContent(isSent, msg),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleContent(bool isSent, Message msg) {
    Widget imageWidget = const SizedBox.shrink();
    if (msg.imagePath != null) {
      imageWidget = GestureDetector(
        onTap: () => _openFullScreenImage(context, msg.imagePath!, msg.imagePath != null),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: msg.imagePath != null
              ? CustomCachedNetworkImage(
            imageUrl: msg.imagePath!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          )
              : Image.file(
            File(msg.imagePath!),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSent)
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 2),
            child: CircleAvatar(
              radius: 16,
              child: ClipOval(
                child: CustomCachedNetworkImage(
                  imageUrl: msg.imagePath ?? 'https://i.pravatar.cc/150?img=1',
                ),
              ),
            ),
          ),
        Flexible(
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (msg.senderLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 2, right: 6),
                    child: CustomText.text(
                      text: msg.senderLabel!,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: msg.repliedTo != null
                        ? (isSent ? const Color(0xffB0D8FF) : Colors.grey.shade200)
                        : (isSent ? const Color(0xffCAEAFF) : Colors.grey.shade200),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isSent ? const Radius.circular(12) : Radius.zero,
                      bottomRight: isSent ? Radius.zero : const Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (msg.repliedTo != null)
                        Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.text(
                                text: msg.repliedTo!.senderLabel ?? 'User',
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                              if (msg.repliedTo!.text != null)
                                CustomText.text(
                                  text: msg.repliedTo!.text!,
                                  fontSize: 11,
                                  color: Colors.grey,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (msg.repliedTo!.imagePath != null)
                                CustomText.text(
                                  text: '[Image]',
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                        ),
                      if (msg.imagePath != null) imageWidget,
                      if (msg.text != null)
                        Padding(
                          padding: EdgeInsets.only(top: msg.imagePath != null ? 6 : 0),
                          child: CustomText.text(
                            text: msg.text!,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            softWrap: true,
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: CustomText.text(
                            text: DateFormat('hh:mm a').format(msg.timestamp),
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSent)
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 2),
            child: CircleAvatar(
              radius: 16,
              child: ClipOval(
                child: CustomCachedNetworkImage(
                  imageUrl: msg.imagePath ?? 'https://i.pravatar.cc/150?img=5',
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _openFullScreenImage(BuildContext context, String imagePath, bool isNetworkImage) {
    screenNavigator(
      context,
      FullScreenImageViewer(
        imagePath: imagePath,
        isNetworkImage: isNetworkImage,
      ),
    );
  }
}


class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;

  const FullScreenImageViewer(
      {required this.imagePath, this.isNetworkImage = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0),
      body: Center(
          child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: isNetworkImage
                  ? CustomCachedNetworkImage(imageUrl: imagePath)
                  : Image.file(File(imagePath)))),
    );
  }
}
