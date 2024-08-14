import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/models/note.dart';

// for static data which never changes
// final notesProvider = Provider((ref) {
//   return notes;
// });

// for dynamic data
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super(notes);

  void addNote(Note note) {
    state = [...state, note];
  }

  void updateNote(Note updatedNote) {
    state = [
      for (final note in state)
        if (note.id == updatedNote.id) updatedNote else note
    ];
  }

  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
