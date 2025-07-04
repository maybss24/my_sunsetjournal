
import 'package:flutter/material.dart';
import 'pages/sunset_entry_screen.dart';

void main() => runApp(const SunsetJournalApp());

class SunsetJournalApp extends StatelessWidget {
  const SunsetJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunset Journal',
      debugShowCheckedModeBanner: false,
      home: const SunsetEntryScreen(),
    );
  }
}