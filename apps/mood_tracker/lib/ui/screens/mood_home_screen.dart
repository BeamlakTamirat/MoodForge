import 'package:flutter/material.dart';

class MoodHomeScreen extends StatelessWidget {
  const MoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: const Center(child: Text('No moods yet!!!😁'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //open mood picker
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
