import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _db;
  static String? _activeEmail; // ✅ Usuario activo

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rumbago.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 🧑‍💼 Tabla de usuarios
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            photoPath TEXT
          )
        ''');

        // 🎉 Tabla de eventos
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

  /// 👤 Insertar usuario nuevo
  static Future<int> insertUser(String name, String email, String password, [String? photoPath]) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'photoPath': photoPath ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 🔍 Obtener usuario por correo
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.first : null;
  }

  /// 🔐 Cambiar contraseña de usuario
  static Future<void> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  /// 🖼 Actualizar ruta de imagen de perfil
  static Future<void> updatePhotoPath(String email, String photoPath) async {
    final db = await database;
    await db.update(
      'users',
      {'photoPath': photoPath},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  /// ✅ Establecer usuario activo (ahora acepta null para cerrar sesión)
  static void setActiveUser(String? email) {
    _activeEmail = email;
  }

  /// ✅ Obtener correo del usuario activo
  static String? get activeUserEmail => _activeEmail;

  /// 🧹 SOLO PARA DESARROLLO: eliminar la base de datos y regenerarla desde cero
  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rumbago.db');
    await deleteDatabase(path);
  }
}
