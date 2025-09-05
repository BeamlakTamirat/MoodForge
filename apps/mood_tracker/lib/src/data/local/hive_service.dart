import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker/src/data/models/mood.dart';
import 'package:flutter/foundation.dart';

class HiveService {
  static const String moodsBoxName = 'moods_box';

  static Future<void> registerAdapters() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MoodAdapter());
    }
    if (!Hive.isBoxOpen(moodsBoxName)) {
      await Hive.openBox<Mood>(moodsBoxName);
    }
  }

  static Box<Mood> getMoodBox() => Hive.box<Mood>(moodsBoxName);

  Future<List<Mood>> getMoods() async {
    final box = getMoodBox();
    return box.values.toList();
  }

  Future<void> addMood(Mood mood) async {
    final box = getMoodBox();
    final key = mood.id.toString();
    try {
      await box.put(key, mood);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'HiveService.addMood failed with key=$key : $e — falling back to box.add()',
        );
      }

      await box.add(mood);
    }
  }

  Future<void> deleteMood(int id) async {
    final box = getMoodBox();
    final key = id.toString();
    if (box.containsKey(key)) {
      await box.delete(key);
      return;
    }
    try {
      await box.delete(id);
    } catch (e) {
      print('HiveService.deleteMood: failed to delete by numeric key $id: $e');
    }
  }

  Future<void> replaceAll(List<Mood> moods) async {
    final box = getMoodBox();
    await box.clear();
    for (final m in moods) {
      await box.put(m.id.toString(), m);
    }
  }
}
