import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/category.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/categories_provider.dart';
import 'package:notes_app/providers/selected_category.dart';
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
  late final ScrollController _scrollController;
  bool _shouldAnimateScroll = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final notes = ref.watch(notesProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final List<Note> filteredNotes = selectedCategory == 'All'
        ? notes
        : notes.where((note) => note.category == selectedCategory).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_shouldAnimateScroll) {
        _scrollToSelectedCategory(selectedCategory, categories);
      }
      _shouldAnimateScroll = true;
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Icon(Icons.ac_unit_sharp),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final categoryName = category.category;
                          final bool isSelected =
                              selectedCategory == categoryName;
                          return GestureDetector(
                            onTap: () {
                              _shouldAnimateScroll = false;
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .selectCategory(
                                      isSelected ? 'All' : categoryName);
                            },
                            child: CategoryContainer(
                              category: categoryName,
                              isSelected: isSelected,
                            ),
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
                            builder: (context) => CategoriesScreen(
                              selectedCategory: selectedCategory,
                            ),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: isDarkMode
                            ? []
                            : [
                                const BoxShadow(
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
                        color: Colors.amber[800],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: notes.isEmpty
                  ? const Center(child: Text("Empty"))
                  : MasonryGridView.builder(
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
          backgroundColor: Colors.amber[800],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewNote(),
              ),
            );
          },
          tooltip: 'Add Note',
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }

  void _scrollToSelectedCategory(
      String selectedCategory, List<Category> categories) {
    final index = categories
        .indexWhere((category) => category.category == selectedCategory);
    if (index != -1) {
      // Calculate the scroll offset
      const itemWidth = 50.0;
      const itemSpacing = 10.0;
      final offset = (itemWidth + itemSpacing) * index;

      // Scroll to the calculated offset with a smooth animation
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    }
  }
}
