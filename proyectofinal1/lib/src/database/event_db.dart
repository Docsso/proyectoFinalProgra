import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'event_model.dart';

class EventDB {
  static Future<Database> _openDB() async {
    final path = join(await getDatabasesPath(), 'rumbago.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            topic TEXT,
            date TEXT,
            description TEXT,
            imagePath TEXT,
            latitude REAL,
            longitude REAL,
            userEmail TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertEvent(EventModel event) async {
    final db = await _openDB();
    await db.insert('events', event.toMap());
  }

  static Future<List<EventModel>> getAllEvents() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) => EventModel.fromMap(maps[i]));
  }

  static Future<List<EventModel>> getEventsByUser(String email) async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'userEmail = ?',
      whereArgs: [email],
    );
    return List.generate(maps.length, (i) => EventModel.fromMap(maps[i]));
  }

  static Future<void> updateEvent(EventModel event) async {
    final db = await _openDB();
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<void> deleteEvent(int id) async {
    final db = await _openDB();
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ✅ Inserta un evento predeterminado si no existe aún para este usuario
  static Future<void> insertDefaultWelcomeEvent(String userEmail) async {
    final db = await _openDB();
    final res = await db.query(
      'events',
      where: 'userEmail = ? AND name = ?',
      whereArgs: [userEmail, 'Evento de Bienvenida'],
    );

    if (res.isEmpty) {
      final defaultEvent = EventModel(
        name: 'Evento de Bienvenida',
        topic: 'Conoce Rumba-Gol!',
        date: '01/01/2025',
        description: 'Este es un evento predeterminado para darte la bienvenida.',
        imagePath: 'assets/images/logo.png',
        latitude: 14.6349,
        longitude: -90.5069,
        userEmail: userEmail,
      );

      await insertEvent(defaultEvent);
    }
  }
}
