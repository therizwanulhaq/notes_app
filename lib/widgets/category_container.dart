// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    required this.category,
    required this.isSelected,
  });

  final String category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
