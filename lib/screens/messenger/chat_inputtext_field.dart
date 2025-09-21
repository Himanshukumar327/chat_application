import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/custom_text.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';
class ChatInputTextField extends StatefulWidget {

  final void Function(String text, List<XFile> images) onSend;
  final Message? repliedToMessage;
  final VoidCallback? onCancelReply;
  final FocusNode? focusNode;

  const ChatInputTextField({
    required this.onSend,
    this.repliedToMessage,
    this.onCancelReply,
    super.key,
    this.focusNode,

  });

  @override
  State<ChatInputTextField> createState() => _ChatInputTextFieldState();
}

class _ChatInputTextFieldState extends State<ChatInputTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  bool _showPopup = false;
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
        if (_hasText) _showPopup = false;
      });
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _showPopup = false);
      }
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    final hasImages = _images.isNotEmpty;
    if (text.isEmpty && !hasImages) return;
    widget.onSend(text, _images);
    _controller.clear();
    setState(() {
      _images.clear();
      _showPopup = false;
    });
    // Clear reply state after sending
    if (widget.onCancelReply != null) {
      widget.onCancelReply!();
    }
  }

  void _togglePopup() {
    FocusScope.of(context).unfocus();
    setState(() => _showPopup = !_showPopup);
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile>? picked = await _picker.pickMultiImage();
      if (picked != null && picked.isNotEmpty) {
        setState(() {
          _images.addAll(picked.take(3 - _images.length));
          _showPopup = false;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          if (_images.length < 3) {
            _images.add(photo);
            _showPopup = false;
          } else {
            Get.snackbar(
                "3 selected", "You can only select up to 3 images");
          }
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.repliedToMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.text(
                            text: widget.repliedToMessage!.senderLabel ?? 'User',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          if (widget.repliedToMessage!.text != null)
                            CustomText.text(
                              text: widget.repliedToMessage!.text!,
                              fontSize: 12,
                              color: Colors.grey,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (widget.repliedToMessage!.imagePath != null)
                            CustomText.text(
                              text: '[Image]',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            if (_images.isNotEmpty)
              Container(
                height: 75,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _images.map((image) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 70,
                          height: 70,
                          child: Image.file(File(image.path), fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _images.remove(image));
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close,
                                  size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

            if (_showPopup) _popupMenu(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(

                              controller: _controller,
                              focusNode: widget.focusNode,
                              decoration: const InputDecoration(
                                hintText: "Write a message...",
                                border: InputBorder.none,
                              ),
                              minLines: 1,
                              maxLines: 5,
                            ),
                          ),
                          GestureDetector(
                            onTap: _togglePopup,
                            child: const Icon(Icons.attach_file,
                                color: Colors.black),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: _handleSend,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xff009A5C),
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: const Alignment(0, -0.1),
                        child: _hasText || _images.isNotEmpty
                            ? const Icon(Icons.send,
                            color: Colors.white, size: 22)
                            : const Icon(Icons.mic_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popupMenu() {
    List<_PopupOption> options = [
      _PopupOption(icon: Icons.camera_alt, label: 'Camera', onTap: _takePhoto),
      _PopupOption(icon: Icons.photo_library, label: 'Gallery', onTap: _pickImage),
      _PopupOption(icon: Icons.insert_drive_file, label: 'Document'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((opt) {
            return GestureDetector(
              onTap: opt.onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: Icon(opt.icon, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  CustomText.text(text: opt.label, fontSize: 13),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

  class _PopupOption {
    final IconData icon;
    final String label;
    final VoidCallback? onTap;

    _PopupOption({required this.icon, required this.label, this.onTap});
  }