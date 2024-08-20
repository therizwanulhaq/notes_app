// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  final String title;
  final String content;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(220),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(120),
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
          const SizedBox(height: 15),
          Text(
            date,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(120),
                ),
          ),
        ],
      ),
    );
  }
}
