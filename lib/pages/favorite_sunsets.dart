import 'dart:io';
import 'package:flutter/material.dart';
import '../sunset_entry.dart';
import '../pages/photo_gallery.dart';

class FavoriteSunsetsPage extends StatelessWidget {
  final List<SunsetEntry> favoriteEntries;
  final void Function(SunsetEntry) onDelete;

  const FavoriteSunsetsPage({
    super.key,
    required this.favoriteEntries,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Sunsets"),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favoriteEntries.isEmpty
            ? const Center(child: Text("No favorite sunsets yet."))
            : ListView.builder(
          itemCount: favoriteEntries.length,
          itemBuilder: (context, index) {
            final entry = favoriteEntries[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GalleryDetailScreen(
                      entry: entry,
                      onDelete: onDelete,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.file(
                        File(entry.image.path),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.pink.shade50,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(" ${entry.date}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Caption: ${entry.caption}"),
                              ],
                            ),
                            const Icon(Icons.favorite, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}