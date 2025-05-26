import 'package:flutter/material.dart';
import 'src/pages/welcome_page.dart'; // Pantalla inicial con botón "VAMOS"

void main() {
  runApp(const RumbaGolApp());
}

class RumbaGolApp extends StatelessWidget {
  const RumbaGolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumba-Gol!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF1F8FF), // Fondo base
      ),
      home: const WelcomePage(), // ✅ Aquí inicia la app
    );
  }
}
