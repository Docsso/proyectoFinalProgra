import 'package:flutter/material.dart';
import 'src/pages/welcome_page.dart';

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
      ),
      home: const WelcomePage(), // Asegúrate que sea esta
    );
  }
}
