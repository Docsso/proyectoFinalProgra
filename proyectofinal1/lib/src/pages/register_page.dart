import 'package:flutter/material.dart';
import '../database/local_db.dart';
import 'menu_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text("Registrarse"),
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
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || !value.contains('@') ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await LocalDatabase.insertUser(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                    );

                    // ✅ IMPORTANTE: guardar usuario activo al registrarse
                    LocalDatabase.activeUserEmail = emailController.text;

                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuPage()),
                      (route) => false,
                    );
                  }
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 