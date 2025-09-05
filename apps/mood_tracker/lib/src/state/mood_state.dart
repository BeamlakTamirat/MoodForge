import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/hive_service.dart';
import '../data/models/mood.dart';

final moodStateProvider =
    ChangeNotifierProvider<MoodState>((ref) => MoodState());

class MoodState extends ChangeNotifier {
  final HiveService _hive = HiveService();
  List<Mood> _moods = [];
  bool _isLoading = false;

  List<Mood> get moods => List.unmodifiable(_moods);
  bool get isLoading => _isLoading;


  MoodState({bool autoLoad = true}) {
    if (autoLoad) {
      loadMoods();
    }
  }

  Future<void> loadMoods() async {
    _isLoading = true;
    notifyListeners();
    final list = await _hive.getMoods();
    list.sort((a, b) => b.date.compareTo(a.date));
    _moods = list;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMood(String moodType, {String? note}) async {
    final mood = Mood.create(moodType: moodType, note: note);
    await _hive.addMood(mood);
    _moods.insert(0, mood);
    notifyListeners();
  }

  Future<void> deleteMood(int id) async {
    await _hive.deleteMood(id);
    _moods.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _hive.replaceAll([]);
    _moods = [];
    notifyListeners();
  }
}