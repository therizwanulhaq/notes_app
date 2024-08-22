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
  bool _isSaved = false;

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
    FocusScope.of(context).unfocus();
    if (_titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
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
    }
    setState(() {
      _isSaved = true;
    });
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
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final formattedDate = DateFormat('MMMM d  h:mm a').format(_date);

    return PopScope(
      onPopInvoked: (didPop) {
        _saveNote();
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? Colors.black
            : Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          scrolledUnderElevation: 0.0,
          backgroundColor: isDarkMode
              ? Colors.black
              : Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: IconButton(
                key: ValueKey<bool>(_isSaved), // Key to differentiate the icons
                onPressed: _saveNote,
                icon: Icon(
                  _isSaved ? Icons.done_all : Icons.done,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            if (widget.existingNote != null || _isSaved)
              PopupMenuButton<String>(
                splashRadius: 100,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                surfaceTintColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
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
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
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
      ),
    );
  }

  void deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Theme.of(context).colorScheme.onSurfaceVariant,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        title: const Text('Delete Note?'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
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
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
