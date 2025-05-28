import 'package:flutter/material.dart';
import '../database/local_db.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

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

    final fetchedUser = await LocalDatabase.getUserByEmail(email);
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
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
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.png'),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              user!['name'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C0033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user!['email'],
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
