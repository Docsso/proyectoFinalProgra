import 'package:flutter/material.dart';
import '../database/event_db.dart';
import '../database/event_model.dart';
import '../database/local_db.dart'; // ✅ Importa para acceder al correo activo
import 'my_event_detail_page.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    final currentUserEmail = LocalDatabase.activeUserEmail;

    if (currentUserEmail != null) {
      final userEvents = await EventDB.getEventsByUser(currentUserEmail);
      setState(() {
        events = userEvents;
      });
    } else {
      setState(() {
        events = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text('Mis eventos'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: events.isEmpty
          ? const Center(child: Text('No has creado eventos aún'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final e = events[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Color(0xFF003366)),
                    title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Temática: ${e.topic}\nFecha: ${e.date}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyEventDetailPage(event: e),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
