import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database/event_db.dart';
import '../database/event_model.dart';
import 'event_detail_page.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventModel> events = [];
  Position? userPosition;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 🔁 Solo obtener eventos del usuario actual
    final loadedEvents = await EventDB.getEventsByUser('demo@rumba.com');

    setState(() {
      userPosition = position;
      events = loadedEvents;
    });
  }

  double _calculateDistance(double lat, double lon) {
    if (userPosition == null) return 0.0;
    return Geolocator.distanceBetween(
          userPosition!.latitude,
          userPosition!.longitude,
          lat,
          lon,
        ) /
        1000; // convert to kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text('Mis eventos cercanos'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: events.isEmpty
          ? const Center(child: Text('No tienes eventos publicados aún'))
          : ListView.builder(
              itemCount: events.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final event = events[index];
                final distance = _calculateDistance(event.latitude, event.longitude);
                return _buildEventCard(event, distance);
              },
            ),
    );
  }

  Widget _buildEventCard(EventModel event, double distance) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          event.imagePath.isNotEmpty && File(event.imagePath).existsSync()
              ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.file(
                    File(event.imagePath),
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Center(child: Text('Sin imagen')),
                ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C0033),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Temática: ${event.topic}'),
                const SizedBox(height: 4),
                Text('Fecha: ${event.date}'),
                const SizedBox(height: 4),
                Text('A ${distance.toStringAsFixed(2)} km de ti'),
                const SizedBox(height: 8),
                Text(event.description),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(event: event),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Detalles'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
