import 'package:flutter/material.dart';
import 'create_event_page.dart';
import 'event_list_page.dart';
import 'welcome_page.dart';
import 'change_password_page.dart';
import 'profile_page.dart';
import 'my_events_page.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Mis eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateEventPage()));
            },
          ),
          const SizedBox(height: 20),
          _MenuButton(
            icon: Icons.directions_walk,
            label: 'Cerca de ti',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EventListPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person, color: Colors.white, size: 28),
              label: const Text('Perfil', style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF524FA1),
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset, color: Colors.white, size: 28),
              label: const Text('Cambiar contraseña', style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              label: const Text('Cerrar sesión', style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003366),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
