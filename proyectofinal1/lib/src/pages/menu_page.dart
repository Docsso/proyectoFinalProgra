import 'package:flutter/material.dart';
import 'create_event_page.dart';
import 'event_list_page.dart';
import 'welcome_page.dart';
import 'change_password_page.dart';
import 'my_events_page.dart';
import 'package:proyectofinal1/src/pages/profile_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeView(),
      const MyEventsPage(),
      const _SettingsView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Mis eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

// 🏠 INICIO
class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MenuButton(
            icon: Icons.event,
            label: 'Organizar evento',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEventPage()),
              );
            },
          ),
          const SizedBox(height: 20),
          _MenuButton(
            icon: Icons.directions_walk,
            label: 'Cerca de ti',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventListPage()),
              );
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ⚙️ AJUSTES
class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SettingsButton(
            label: 'Perfil',
            icon: Icons.person,
            color: Colors.indigo,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(height: 20),
          _SettingsButton(
            label: 'Cambiar contraseña',
            icon: Icons.lock_reset,
            color: const Color(0xFF003366),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              );
            },
          ),
          const SizedBox(height: 20),
          _SettingsButton(
            label: 'Cerrar sesión',
            icon: Icons.logout,
            color: Colors.red,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
                    (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// 🔁 Botón reutilizable
class _SettingsButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _SettingsButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// 🧱 Botón de inicio reutilizable
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003366),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
