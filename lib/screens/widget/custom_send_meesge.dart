import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
class ChatTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String hintText;
  final Widget? suffixIcon; // Changed from IconData? to Widget?
  final bool showClearButton; // New: To control clear button visibility

  const ChatTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.suffixIcon,
    this.showClearButton = true, required Future<void> Function() onSend, // Default: true
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      onChanged: onChanged,
      maxLines: 1,
      keyboardType: TextInputType.multiline,
      maxLength: 15,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14.sp,
        ),
        suffixIcon: showClearButton && controller?.text.isNotEmpty == true
            ? InkWell(
          onTap: () {
            controller?.clear();
            if (onChanged != null) onChanged!('');
          },
          child: Icon(Icons.clear, color: Colors.grey[500], size: 18.sp),
        )
            : suffixIcon,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 8.sp, right: 3.sp),
          child: Icon(
            Icons.search,
            color: Colors.grey[500],
          ),
        ),
        counterText: '',
        prefixIconConstraints: BoxConstraints(
          minWidth: 10.w,
          minHeight: 10.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
