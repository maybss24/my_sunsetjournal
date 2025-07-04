import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'pages/photo_gallery.dart';
import 'pages/favorite_sunsets.dart';
import '../sunset_entry.dart';

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  final List<SunsetEntry> _entries = [];
  String _searchQuery = '';
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final image = File(pickedFile.path);
    String caption = '', description = '';
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Sunset Entry"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Caption'),
                  onChanged: (val) => caption = val,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (val) => description = val,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) selectedDate = picked;
                  },
                  child: const Text("Select Date"),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _entries.insert(
                    0,
                    SunsetEntry(
                      image: image,
                      caption: caption,
                      description: description,
                      date: DateFormat('EEEE, MMMM d, y').format(selectedDate),
                      rawDate: selectedDate,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(SunsetEntry entry) {
    setState(() => _entries.remove(entry));
  }

  List<SunsetEntry> get _filteredEntries {
    final query = _searchQuery.toLowerCase();

    List<SunsetEntry> exactDateMatches = [];
    List<SunsetEntry> sameYearMatches = [];

    for (var entry in _entries) {
      final matchesSearch = entry.caption.toLowerCase().contains(query) ||
          entry.description.toLowerCase().contains(query);

      if (!matchesSearch) continue;

      if (_selectedDate != null) {
        if (entry.rawDate.year != _selectedDate!.year) continue;

        if (entry.rawDate.year == _selectedDate!.year &&
            entry.rawDate.month == _selectedDate!.month &&
            entry.rawDate.day == _selectedDate!.day) {
          exactDateMatches.add(entry);
        } else {
          sameYearMatches.add(entry);
        }
      } else {
        sameYearMatches.add(entry); // all if no date filter
      }
    }

    exactDateMatches.sort((a, b) => b.rawDate.compareTo(a.rawDate));
    sameYearMatches.sort((a, b) => b.rawDate.compareTo(a.rawDate));

    return [...exactDateMatches, ...sameYearMatches];
  }

  List<SunsetEntry> get _favoriteEntries =>
      _entries.where((e) => e.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sunset Journal"),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear Filter',
            onPressed: () {
              setState(() {
                _selectedDate = null;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "The sunset is\nbeautiful, isn’t it?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteSunsetsPage(
                            favoriteEntries: _favoriteEntries,
                            onDelete: _deleteEntry,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PhotoGallery(
                            entries: _entries,
                            title: "Sunset Gallery",
                            onDelete: _deleteEntry,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: "Search by caption or description...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 20),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Filtered by date: ${DateFormat('MMMM d, y').format(_selectedDate!)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Expanded(
            child: _filteredEntries.isEmpty
                ? const Center(child: Text("No matching sunset entries found."))
                : ListView.builder(
              itemCount: _filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = _filteredEntries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GalleryDetailScreen(
                            entry: entry,
                            onDelete: _deleteEntry,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.file(
                            entry.image,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.pink.shade50,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Caption: ${entry.caption}"),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    entry.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: entry.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => entry.isFavorite =
                                    !entry.isFavorite);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
} 