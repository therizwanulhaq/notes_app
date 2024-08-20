import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  Category({
    String? id,
    required this.category,
  }) : id = id ?? uuid.v4();
  final String id;
  final String category;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      category: map['category'],
    );
  }
}
