import 'package:hive/hive.dart';

part 'mood.g.dart';

@HiveType(typeId: 0)
class Mood extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String moodType;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final DateTime date;

  Mood({
    required this.id,
    required this.moodType,
    this.note,
    required this.date,
  });

  factory Mood.create({required String moodType, String? note}) {
    return Mood(
      id: DateTime.now().millisecondsSinceEpoch,
      moodType: moodType,
      note: note,
      date: DateTime.now(),
    );
  }
}