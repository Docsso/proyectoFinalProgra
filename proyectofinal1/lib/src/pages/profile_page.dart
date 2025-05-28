import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../database/local_db.dart';
import 'change_password_page.dart';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = LocalDatabase.activeUserEmail;
    if (email == null) {
      setState(() {
        user = null;
        isLoading = false;
      });
      return;
    }

    final data = await LocalDatabase.getUserByEmail(email);

    File? loadedImage;
    if (data != null && data['photoPath'] != null && data['photoPath'] != '') {
      final file = File(data['photoPath']);
      if (await file.exists()) {
        loadedImage = file;
      }
    }

    setState(() {
      user = data;
      profileImage = loadedImage;
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final newPath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}_profile.png';
    final newImage = await File(pickedFile.path).copy(newPath);

    final email = LocalDatabase.activeUserEmail;
    if (email != null) {
      await LocalDatabase.updatePhotoPath(email, newImage.path);
      final updatedUser = await LocalDatabase.getUserByEmail(email);
      setState(() {
        user = updatedUser;
        profileImage = newImage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto actualizada correctamente')),
      );
    }
  }

  void _logout() {
    LocalDatabase.setActiveUser(null);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  void _goToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text("Mi perfil"),
        backgroundColor: const Color(0xFF003366),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('No se encontró información del usuario'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : const AssetImage('assets/images/logo.png') as ImageProvider,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                        ),
                        child: const Text("Editar foto"),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        user!['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C0033),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user!['email'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.lock_reset, color: Colors.white),
                        label: const Text("Cambiar contraseña", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _goToChangePassword,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text("Cerrar sesión", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ),
    );
  }
}
