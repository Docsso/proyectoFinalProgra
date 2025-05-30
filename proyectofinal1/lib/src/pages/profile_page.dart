import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/local_db.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (LocalDatabase.activeUserEmail != null) {
      final user = await LocalDatabase.getUserByEmail(LocalDatabase.activeUserEmail!);
      if (user != null && mounted) {
        setState(() {
          userName = user['name'];
          userEmail = user['email'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
              ),
              child: const Text('Cambiar foto de perfil', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (userName != null)
              Text(
                userName!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            if (userEmail != null)
              Text(
                userEmail!,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
