import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'profile_page.dart';
import '../database/local_db.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = LocalDatabase.activeUserEmail != null;

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

              if (!isLoggedIn) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text("Iniciar sesión", style: TextStyle(color: Colors.white)),
                  onPressed: () => _goToLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration, color: Colors.white),
                  label: const Text("Registrarse", style: TextStyle(color: Colors.white)),
                  onPressed: () => _goToRegister(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ] else ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text("Perfil", style: TextStyle(color: Colors.white)),
                  onPressed: () => _goToProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
