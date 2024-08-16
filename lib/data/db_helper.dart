import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/models/note.dart';

class DBHelper {
  static Database? _database;

  static const String _tableName = 'notes';

  // Initialize the database
  static Future<void> init() async {
    if (_database != null) {
      return;
    }

    try {
      String path = join(await getDatabasesPath(), 'notes.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, category TEXT)',
          );
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // Insert a note into the database
  static Future<void> insertNote(Note note) async {
    await _database?.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all notes from the database
  static Future<List<Note>> getNotes() async {
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);

    return List.generate(
      maps.length,
      (i) {
        return Note.fromMap(maps[i]);
      },
    );
  }

  // Update a note in the database
  static Future<void> updateNote(Note note) async {
    await _database?.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a note from the database
  static Future<void> deleteNote(String id) async {
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
