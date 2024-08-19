import 'package:notes_app/data/categories.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/models/category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/models/note.dart';

class DBHelper {
  static Database? _database;

  static const String _notesTable = 'notes';

  static const String _categoriesTable = 'categories';

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
            'CREATE TABLE $_categoriesTable(id TEXT PRIMARY KEY, category TEXT)',
          );

          await db.execute(
            'CREATE TABLE $_notesTable(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, category TEXT)',
          );

          // Insert default categories
          for (var category in defaultCategories) {
            await db.insert(
              _categoriesTable,
              category.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          // Insert default notes during database creation
          for (var note in defaultNotes) {
            await db.insert(
              _notesTable,
              note.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // Insert a category into database
  static Future<void> insertCategory(Category category) async {
    await _database?.insert(
      _categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert a note into the database
  static Future<void> insertNote(Note note) async {
    await _database?.insert(
      _notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all notes from the database
  static Future<List<Note>> getNotes() async {
    final List<Map<String, dynamic>> maps = await _database!.query(_notesTable);

    return List.generate(
      maps.length,
      (i) {
        return Note.fromMap(maps[i]);
      },
    );
  }

  // Retrieve all categories from the db
  static Future<List<Category>> getCategories() async {
    final List<Map<String, dynamic>> maps =
        await _database!.query(_categoriesTable);

    return List.generate(
      maps.length,
      (index) => Category.fromMap(
        maps[index],
      ),
    );
  }

  // Update a note in the database
  static Future<void> updateNote(Note note) async {
    await _database?.update(
      _notesTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a note from the database
  static Future<void> deleteNote(String id) async {
    await _database?.delete(
      _notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteCategory(String id) async {
    await _database?.delete(
      _categoriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
