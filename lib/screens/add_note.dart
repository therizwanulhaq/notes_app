import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({
    super.key,
    required this.onAddNote,
    this.existingNote,
  });

  final void Function(Note note) onAddNote;
  final Note? existingNote;

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
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

    widget.onAddNote(note);
    Navigator.pop(context);
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
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.check),
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
}
