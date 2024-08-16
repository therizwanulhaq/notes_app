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

  // Convert a Note object into a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  // Create a Note object from a Map<String, dynamic>
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}
