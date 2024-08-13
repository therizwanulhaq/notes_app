import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/widgets/category_container.dart';
import 'package:notes_app/widgets/note_container.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _notes = notes;

  final List<String> categories = [
    "All",
    "Work",
    "Personal",
    "Study",
    "Uncategorized",
  ];

  void _addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
  }

  void _updateNote(Note updatedNote) {
    setState(() {
      final index = _notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Icon(Icons.ac_unit_sharp),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryContainer(
                            category: category,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 5.0,
                        ),
                      ],
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      color: Colors.amber[700],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MasonryGridView.builder(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: _notes.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  final title = note.title;
                  final content = note.content;
                  final formattedDate =
                      DateFormat('d MMM yyyy').format(note.date);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewNote(
                            onAddNote: _updateNote,
                            existingNote: note,
                          ),
                        ),
                      );
                    },
                    child: NoteContainer(
                      title: title,
                      content: content,
                      date: formattedDate,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          right: 20,
        ),
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(181, 255, 162, 0),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewNote(
                  onAddNote: _addNote,
                ),
              ),
            );
          },
          tooltip: 'Add Note',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
