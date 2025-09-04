class Mood {
  final DateTime date;
  final String emoji;
  final String? note;

  Mood({required this.date, required this.emoji, this.note});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'emoji': emoji,
    'note': note,
  };

  factory Mood.fromJson(Map<String, dynamic> json)=>Mood(
    date: DateTime.parse(json['date']),
    emoji: json['emoji'],
    note: json['note'],
  );
}
