import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/categories.dart';

class AddNewNote extends ConsumerStatefulWidget {
  const AddNewNote({
    super.key,
    this.existingNote,
  });

  final Note? existingNote;

  @override
  ConsumerState<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends ConsumerState<AddNewNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  int _charCount = 0;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
    _charCount = _contentController.text.length;
    _date = widget.existingNote?.date ?? DateTime.now();
    _contentController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _contentController.text.length;
    });
  }

  void _saveNote() {
    final note = Note(
      id: widget.existingNote
          ?.id, // Use existing id if editing, otherwise it will generate a new one
      title: _titleController.text,
      content: _contentController.text,
      date: _date,
      category: widget.existingNote?.category ??
          'Uncategorized', // Retain existing category if editing
    );

    if (widget.existingNote != null) {
      ref.read(notesProvider.notifier).updateNote(note);
    } else {
      ref.read(notesProvider.notifier).addNote(note);
    }
    Navigator.pop(context);
  }

  void _handleMoreOption(String option) {
    // Handle different options
    switch (option) {
      case 'Share':
        // Code to share the note
        break;
      case 'Archive':
        // Code to archive the note
        break;
      case 'Move to':
        // Code to set category on note
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CategoriesScreen(existingNote: widget.existingNote),
            ));
        break;
      case 'Delete':
        deleteNote();
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d  h:mm a').format(_date);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.check),
          ),
          PopupMenuButton<String>(
            splashRadius: 100,
            color: Theme.of(context).colorScheme.background,
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMoreOption,
            itemBuilder: (BuildContext context) =>
                {'Share', 'Archive', 'Move to', 'Delete'}.map(
              (String choice) {
                return PopupMenuItem<String>(
                  padding: const EdgeInsets.only(
                    right: 40,
                    left: 20,
                  ),
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ).toList(),
            offset: const Offset(-20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "  |  $_charCount characters",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              if (widget.existingNote != null)
                Text(widget.existingNote!.category),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Start typing...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                maxLines: null,
                expands: false,
                textInputAction: TextInputAction.newline,
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(notesProvider.notifier)
                  .deleteNote(widget.existingNote!.id);

              // Show a SnackBar after deleting the note
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Close the AddNewNote screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
