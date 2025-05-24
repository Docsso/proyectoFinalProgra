import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'event_model.dart';

class EventDB {
  static Future<Database> _openDB() async {
    final path = join(await getDatabasesPath(), 'rumbago.db');
    return openDatabase(
      path,
      version: 3, // 🔄 Incrementamos la versión para aplicar cambios en tabla
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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            ALTER TABLE events ADD COLUMN userEmail TEXT
          ''');
        }
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
}
