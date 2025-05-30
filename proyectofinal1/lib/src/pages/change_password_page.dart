import 'package:flutter/material.dart';
import '../database/local_db.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Future<void> _changePassword() async {
    final current = currentPassController.text.trim();
    final newPass = newPassController.text.trim();
    final confirm = confirmPassController.text.trim();

    final email = LocalDatabase.activeUserEmail;

    if (email == null) {
      _showSnackBar('Usuario no identificado', isError: true);
      return;
    }

    final user = await LocalDatabase.getUserByEmail(email);

    if (user == null) {
      _showSnackBar('Usuario no encontrado', isError: true);
      return;
    }

    if (current != user['password']) {
      _showSnackBar('Contraseña actual incorrecta', isError: true);
      return;
    }

    if (newPass != confirm) {
      _showSnackBar('Las contraseñas no coinciden', isError: true);
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar('La nueva contraseña debe tener al menos 6 caracteres', isError: true);
      return;
    }

    await LocalDatabase.updateUserPassword(email, newPass);
    _showSnackBar('Contraseña actualizada correctamente');
    Navigator.pop(context);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(isError ? Icons.error : Icons.check_circle, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green[700],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña actual',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar nueva contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('Guardar cambios'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
