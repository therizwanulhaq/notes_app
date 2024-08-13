import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Note {
  Note({
    String? id,
    required this.title,
    required this.content,
    required this.date,
    this.category = "Uncategorized",
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String content;
  final DateTime date;
  String category;

  void setCategory(String newCategory) {
    category = newCategory;
  }
}
