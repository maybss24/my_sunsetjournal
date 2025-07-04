import 'dart:io';
import 'package:flutter/material.dart';
import '../sunset_entry.dart';

class PhotoGallery extends StatelessWidget {
  final List<SunsetEntry> entries;
  final String title;
  final void Function(SunsetEntry) onDelete;

  const PhotoGallery({
    super.key,
    required this.entries,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("No sunset photos to display."))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(entry.image.path),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GalleryDetailScreen extends StatelessWidget {
  final SunsetEntry entry;
  final void Function(SunsetEntry) onDelete;

  const GalleryDetailScreen({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Photo"),
        content: const Text("Are you sure you want to delete this sunset photo?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onDelete(entry);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to gallery
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: Text(entry.date, style: const TextStyle(color: Colors.white)), // <--- FIXED
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                entry.image,
                width: double.infinity,
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Caption", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(entry.caption, style: const TextStyle(fontSize: 16)),
                  const Divider(height: 30, thickness: 1),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    entry.description,
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

