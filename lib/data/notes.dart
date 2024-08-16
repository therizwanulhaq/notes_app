import 'package:notes_app/models/note.dart';

final List<Note> defaultNotes = [
  Note(
    title: 'Welcome to Notes App',
    content: 'This is your first note. Feel free to edit or delete it.',
    date: DateTime.now(),
    category: 'General',
  ),
  Note(
    title: 'Quick Tip',
    content: 'Swipe right to delete a note.',
    date: DateTime.now(),
    category: 'Tips',
  ),
  Note(
    title: 'Another Note',
    content: 'Add your thoughts here!',
    date: DateTime.now(),
    category: 'Personal',
  ),
];
