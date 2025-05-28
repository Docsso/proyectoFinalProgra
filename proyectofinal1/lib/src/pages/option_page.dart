import 'package:flutter/material.dart';
import '../database/local_db.dart';
import 'profile_page.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({super.key});

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text("Ajustes"),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.person, color: Colors.white),
                label: const Text("Perfil", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => _goToProfile(context),
              ),
              // 👇 Botones eliminados del visual:
              // const SizedBox(height: 12),
              // ElevatedButton.icon(... Cambiar contraseña ...)
              // const SizedBox(height: 12),
              // ElevatedButton.icon(... Cerrar sesión ...)
            ],
          ),
        ),
      ),
    );
  }
}
