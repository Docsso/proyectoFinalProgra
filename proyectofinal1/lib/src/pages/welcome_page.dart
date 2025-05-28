import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'option_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    pedirPermisos();
  }

  Future<void> pedirPermisos() async {
    final fotos = await Permission.photos.request();
    final ubicacion = await Permission.locationWhenInUse.request();

    if (fotos.isGranted && ubicacion.isGranted) {
      print('✅ Todos los permisos concedidos');
    } else {
      print('❌ Permisos denegados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C0033),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 160,
              ),
              const SizedBox(height: 30),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'La mejor app para buscar eventos para interactuar',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const OptionPage()),
                  );
                },
                child: const Text(
                  'VAMOS',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
