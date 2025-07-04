import 'dart:io';

class SunsetEntry {
  final File image;
  final String caption;
  final String description;
  final String date;
  final DateTime rawDate;
  bool isFavorite;

  SunsetEntry({
    required this.image,
    required this.caption,
    required this.description,
    required this.date,
    required this.rawDate,
    this.isFavorite = false,
  });
} 