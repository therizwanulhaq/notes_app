import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/db_helper.dart';
import 'package:notes_app/models/category.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]) {
    _loadCategories();
  }

  // Load categories from the db
  Future<void> _loadCategories() async {
    await DBHelper.init();
    state = await DBHelper.getCategories();
  }

  Future<void> addCategory(Category category) async {
    await DBHelper.insertCategory(category);
    state = [...state, category];
  }

  Future<void> deleteCategory(String id) async {
    await DBHelper.deleteCategory(id);
    state = state.where((category) => category.id != id).toList();
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
  (ref) => CategoriesNotifier(),
);
