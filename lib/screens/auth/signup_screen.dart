import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/widget/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../bottomnavigation_screen.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? _image;

  /// Image picker
  Future<void> pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> uploadImage(String uid) async {
    try {
      final ref = FirebaseStorage.instance.ref().child("profile_images").child("$uid.jpg");
      await ref.putFile(_image!);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Image upload failed: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  /// Signup function
  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      Get.snackbar("Error", "Please upload a profile image",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    try {
      var auth = FirebaseAuth.instance;
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());

      final user = userCredential.user;
      if (user != null) {
        String? imageUrl = await uploadImage(user.uid);

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "fullName": fullName.text.trim(),
          "email": email.text.trim(),
          "imageUrl": imageUrl,
          "createdAt": FieldValue.serverTimestamp(),
        });

        Get.snackbar("Success", "Account created successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.off(() => BottomNavScreen());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background_img.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Signup form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Profile Image
                          GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey[600])
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Title
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sign up to get started",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 32),

                          /// Fields
                          textField(
                            controller: fullName,
                            hint: "Full Name",
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                            value == null || value.isEmpty ? "Full Name required" : null,
                          ),
                          const SizedBox(height: 16),

                          textField(
                            controller: email,
                            hint: "Email Address",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Email required";
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) return "Enter valid email";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          textField(
                            controller: password,
                            hint: "Password",
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Password required";
                              final passRegex =
                              RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$'); // min 6, 1 upper, 1 num
                              if (!passRegex.hasMatch(value)) {
                                return "At least 6 chars, 1 uppercase, 1 number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          textField(
                            controller: confirmPassword,
                            hint: "Confirm Password",
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value != password.text) return "Passwords do not match";
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          /// Sign Up button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: signUp,
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Already have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Get.off(() => LoginScreen());
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
