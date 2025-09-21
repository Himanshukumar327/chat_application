import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  TextInputType? keyboardType,
  bool obscureText = false,
  String? Function(String?)? validator, // 👈 validator add
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator, // 👈 yaha use kiya
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blue.shade700),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
