import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/src/state/mood_state.dart';
import 'package:mood_tracker/src/data/models/mood.dart';

class MoodHomePage extends ConsumerWidget {
  const MoodHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodStateProvider);
    final notifier = ref.read(moodStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear all (dev)',
            onPressed: state.moods.isEmpty
                ? null
                : () async {
                    final confirmed = await showDialog<bool?>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Clear all moods?'),
                        content:
                            const Text('This will delete all saved moods.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(c).pop(false),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () => Navigator.of(c).pop(true),
                              child: const Text('Clear')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await notifier.clearAll();
                    }
                  },
          )
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.moods.isEmpty
              ? const Center(child: Text('No moods yet. Tap + to add one.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.moods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final m = state.moods[i];
                    return _MoodCard(
                      mood: m,
                      onDelete: () => notifier.deleteMood(m.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddDialog(BuildContext context, MoodState notifier) async {
    final TextEditingController noteController = TextEditingController();
    String selectedEmoji = '😊';

    await showDialog(
      context: context,
      builder: (c) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Mood'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  children: ['😊', '😢', '😡', '🤩', '😴', '😐', '😅']
                      .map((e) => ChoiceChip(
                            key: ValueKey('emoji_$e'),
                            label: Text(e, style: const TextStyle(fontSize: 20)),
                            selected: selectedEmoji == e,
                            onSelected: (sel) {
                              setState(() {
                                selectedEmoji = e;
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const ValueKey('note_field'),
                  controller: noteController,
                  decoration: const InputDecoration(hintText: 'Optional note'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(c).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final note = noteController.text.trim();
                    notifier.addMood(selectedEmoji,
                        note: note.isEmpty ? null : note);
                    Navigator.of(c).pop();
                  },
                  child: const Text('Add')),
            ],
          );
        });
      },
    );
  }
}

class _MoodCard extends StatelessWidget {
  final Mood mood;
  final VoidCallback onDelete;
  const _MoodCard({required this.mood, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(mood.moodType, style: const TextStyle(fontSize: 28)),
        title: Text(mood.note ?? 'No note'),
        subtitle: Text('${mood.date.toLocal()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}