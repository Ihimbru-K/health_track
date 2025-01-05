class JournalEntry {
  final int? id;
  final String text;
  final String mood;
  final DateTime date;

  JournalEntry({
    this.id,
    required this.text,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'mood': mood,
      'date': date.toIso8601String(),
    };
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      text: map['text'],
      mood: map['mood'],
      date: DateTime.parse(map['date']),
    );
  }
}


