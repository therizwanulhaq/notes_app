import 'package:notes_app/models/note.dart';

final List<Note> defaultNotes = [
  Note(
    title: 'Welcome to Notes App',
    content: 'This is a placeholder note to get you started!',
    category: 'Uncategorized',
    date: DateTime.now(),
  ),
  Note(
    title: 'Getting Started',
    content: 'Click the "+" button to add a new note.\n'
        'Tap on a note to edit it.\n'
        'Click the options on top right corner to delete your notes.\n'
        'Use the categories to organize your notes.',
    category: 'Instructions',
    date: DateTime.now(),
  ),
  Note(
    title: 'Organize with Categories',
    content: 'You can categorize your notes for better organization.\n'
        'Navigate to the categories screen to manage your categories.\n'
        'Click on a category to filter the notes.',
    category: 'Instructions',
    date: DateTime.now(),
  ),
  Note(
    title: "Quick Tip",
    content: 'Swipe right to delete a note.',
    category: 'Instructions',
    date: DateTime.now(),
  ),
  Note(
    title: 'Dark Mode',
    content: 'Your notes app supports dark mode.\n'
        'It will automatically adapt to your system theme settings.',
    category: 'Features',
    date: DateTime.now(),
  ),
];
