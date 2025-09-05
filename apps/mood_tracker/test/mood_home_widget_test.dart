// apps/mood_tracker/test/mood_home_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// adjust import paths as required for your repo
import 'package:mood_tracker/src/features/moods/presentation/pages/mood_home_page.dart';
import 'package:mood_tracker/src/state/mood_state.dart';
import 'package:mood_tracker/src/data/models/mood.dart';

/// FakeMoodState extends the real MoodState but disables auto-loading
/// from Hive via the constructor super(autoLoad: false).
class FakeMoodState extends MoodState {
  final List<Mood> _list = [];
  bool _loading = false;

  int addCalls = 0;
  String? lastAddedEmoji;
  String? lastAddedNote;

  FakeMoodState() : super(autoLoad: false);

  @override
  List<Mood> get moods => List.unmodifiable(_list);

  @override
  bool get isLoading => _loading;

  @override
  Future<void> loadMoods() async {
    // keep _loading false for tests; nothing to load
    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> addMood(String moodType, {String? note}) async {
    addCalls++;
    lastAddedEmoji = moodType;
    lastAddedNote = note;
    final mood = Mood.create(moodType: moodType, note: note);
    _list.insert(0, mood);
    notifyListeners();
  }

  @override
  Future<void> deleteMood(int id) async {
    _list.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  @override
  Future<void> clearAll() async {
    _list.clear();
    notifyListeners();
  }
}

void main() {
  testWidgets('Add mood via dialog calls addMood on provider', (tester) async {
    final fake = FakeMoodState();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // override the provider with our fake instance
          moodStateProvider.overrideWith((ref) => fake),
        ],
        child: const MaterialApp(home: MoodHomePage()),
      ),
    );

    // settle initial frame
    await tester.pumpAndSettle();

    // Find FAB and tap
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    // Tap one emoji choice chip (use the ValueKey used in the dialog)
    final emojiChip = find.byKey(const ValueKey('emoji_🤩'));
    expect(emojiChip, findsOneWidget);
    await tester.tap(emojiChip);
    await tester.pumpAndSettle();

    // Enter a note
    final noteField = find.byKey(const ValueKey('note_field'));
    expect(noteField, findsOneWidget);
    await tester.enterText(noteField, 'Hello test');

    // Tap Add button (text 'Add')
    final addButton = find.widgetWithText(TextButton, 'Add');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify the fake state recorded the addition
    expect(fake.addCalls, 1);
    expect(fake.lastAddedEmoji, '🤩');
    expect(fake.lastAddedNote, 'Hello test');

    // And verify UI shows the mood card (should show the note text)
    final moodCard = find.text('Hello test');
    expect(moodCard, findsOneWidget);
  });
}
