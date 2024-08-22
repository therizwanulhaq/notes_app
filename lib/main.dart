import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/screens/homepage.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.black,
          background: Colors.black,
          secondaryContainer: const Color.fromARGB(255, 32, 32, 32),
          onPrimary: Colors.white,
          onSecondary: Colors.grey,
          onSurfaceVariant: const Color.fromARGB(255, 61, 61, 61),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          background: const Color.fromARGB(255, 238, 238, 238),
          secondaryContainer: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.grey,
          onSurfaceVariant: const Color.fromARGB(255, 240, 240, 240),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
