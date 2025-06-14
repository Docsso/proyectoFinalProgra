import 'package:flutter/material.dart';
import '../database/local_db.dart';
import '../database/event_db.dart'; // ✅ Importamos EventDB
import '../database/event_model.dart'; // ✅ Importamos EventModel
import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _insertDefaultEventIfNeeded(String userEmail) async {
    final existingEvents = await EventDB.getEventsByUser(userEmail);
    final alreadyExists = existingEvents.any((e) => e.name == 'Evento de Bienvenida');

    if (!alreadyExists) {
      final defaultEvent = EventModel(
        name: 'Evento de Bienvenida',
        topic: 'Conoce Rumba-Gol!',
        date: '01/01/2025',
        description: 'Este es un evento predeterminado para darte la bienvenida.',
        imagePath: 'assets/images/logo.png',
        latitude: 14.6349,
        longitude: -90.5069,
        userEmail: userEmail,
      );
      await EventDB.insertEvent(defaultEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text("Iniciar sesión"),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Contraseña muy corta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState!.validate()) {
                    final user = await LocalDatabase.getUserByEmail(emailController.text);
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario no encontrado')),
                      );
                    } else if (user['password'] != passwordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contraseña incorrecta')),
                      );
                    } else {
                      LocalDatabase.activeUserEmail = user['email'];
                      await _insertDefaultEventIfNeeded(user['email']);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPage()),
                            (route) => false,
                      );
                    }
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
