import 'package:flutter/material.dart';
import 'src/pages/welcome_page.dart';
import 'src/database/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        scaffoldBackgroundColor: const Color(0xFFF1F8FF),
      ),
      home: const WelcomePage(), // ✅ Siempre carga esta pantalla primero
    );
  }
}
