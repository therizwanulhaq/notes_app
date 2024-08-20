// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:notes_app/models/category.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/categories_provider.dart';
import 'package:notes_app/providers/notes_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({
    super.key,
    this.existingNote,
  });

  final Note? existingNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Folders"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showNewFolderDialog(context, ref);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        children: [
          for (final category in categories) ...[
            Slidable(
              key: ValueKey(category.id),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) => {
                      deleteCategoryFolder(context, ref, category.id),
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  )
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(category.category),
                  trailing: const Text("23"),
                  onTap: () => _moveNoteToCategory(ref, context, category),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  void _moveNoteToCategory(
      WidgetRef ref, BuildContext context, Category category) {
    if (existingNote?.id != null) {
      // Update the note with the selected category
      final notesNotifier = ref.read(notesProvider.notifier);
      final note = ref
          .read(notesProvider)
          .firstWhere((note) => note.id == existingNote?.id);
      note.setCategory(category.category);
      notesNotifier.updateNote(note);

      // Navigate back after updating
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void _showNewFolderDialog(BuildContext context, WidgetRef ref) {
    TextEditingController folderNameController = TextEditingController();
    FocusNode focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New folder',
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
              controller: folderNameController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Folder Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                String folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  final newCategory = Category(category: folderName);
                  ref
                      .read(categoriesProvider.notifier)
                      .addCategory(newCategory);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCategoryFolder(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete folder?"),
        content: const Text('Are you sure you want to delete this folder?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(categoriesProvider.notifier).deleteCategory(id);

              // Show a SnackBar after deleting the category
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Folder deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
