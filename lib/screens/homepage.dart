import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/categories_provider.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/screens/categories.dart';
import 'package:notes_app/widgets/category_container.dart';
import 'package:notes_app/widgets/note_container.dart';
import 'package:notes_app/providers/notes_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  var selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    final categories = ref.watch(categoriesProvider);

    final List<Note> filteredNotes = selectedCategory == 'All'
        ? notes
        : notes.where((note) => note.category == selectedCategory).toList();

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
      body: notes.isEmpty
          ? const Center(child: Text("Empty"))
          : Padding(
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
                                final categoryName = category.category;
                                final bool isSelected =
                                    selectedCategory == categoryName;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category.category;
                                    });
                                  },
                                  child: CategoryContainer(
                                      category: categoryName,
                                      isSelected: isSelected),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesScreen(),
                                ));
                          },
                          child: Container(
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: Colors.amber[700],
                            ),
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
                      itemCount: filteredNotes.length,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
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
                builder: (context) => const AddNewNote(),
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
