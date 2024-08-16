import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/db_helper.dart';
import 'package:notes_app/models/note.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]) {
    _loadNotes();
  }

  // Load notes from the database
  Future<void> _loadNotes() async {
    await DBHelper.init();
    state = await DBHelper.getNotes();
  }

  Future<void> addNote(Note note) async {
    await DBHelper.insertNote(note);
    state = [...state, note];
  }

  Future<void> updateNote(Note updatedNote) async {
    await DBHelper.updateNote(updatedNote);
    state = [
      for (final note in state)
        if (note.id == updatedNote.id) updatedNote else note
    ];
  }

  Future<void> deleteNote(String id) async {
    await DBHelper.deleteNote(id);
    state = state.where((note) => note.id != id).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
