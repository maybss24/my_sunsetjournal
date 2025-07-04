import 'package:flutter/material.dart';
import '../pages/journal_home_page.dart';

class SunsetEntryScreen extends StatelessWidget {
  const SunsetEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/sunsetgirl.jpg',
                width: double.infinity,
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              '“Together, we watched the sky catch fire. The sun dipped low, and in that quiet moment, everything felt infinite.”',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JournalHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("Get started",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
