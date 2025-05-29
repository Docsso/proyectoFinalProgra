import 'dart:io';
import 'package:flutter/material.dart';
import '../database/event_model.dart';

class MyEventDetailPage extends StatelessWidget {
  final EventModel event;

  const MyEventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      appBar: AppBar(
        title: const Text('Detalles del evento'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imagePath.isNotEmpty && File(event.imagePath).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(event.imagePath),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('Sin imagen')),
              ),
            const SizedBox(height: 20),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C0033),
              ),
            ),
            const SizedBox(height: 10),
            Text('📅 Fecha: ${event.date}'),
            const SizedBox(height: 5),
            Text('🎯 Temática: ${event.topic}'),
            const SizedBox(height: 5),
            Text('📍 Ubicación: (${event.latitude}, ${event.longitude})'),
            const SizedBox(height: 20),
            const Text(
              '📝 Descripción',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}