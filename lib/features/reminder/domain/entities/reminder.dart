class Reminder {
  final int id;
  final String title;
  final DateTime dateTime;

  Reminder({
    required this.id,
    required this.title,
    required this.dateTime,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as int,
      title: json['title'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
