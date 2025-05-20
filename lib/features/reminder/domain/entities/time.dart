class Time {
  final int hour;
  final int minute;

  const Time(this.hour, this.minute);

  factory Time.fromDateTime(DateTime dateTime) {
    return Time(dateTime.hour, dateTime.minute);
  }

  factory Time.fromString(String s) {
    final parts = s.split(':');
    return Time(int.parse(parts[0]), int.parse(parts[1]));
  }

  DateTime toDateTime({DateTime? baseDate}) {
    final now = baseDate ?? DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
