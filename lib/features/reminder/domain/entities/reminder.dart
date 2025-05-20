import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';

class Reminder {
  final int? id;
  int? deviceId;
  final int? userId;
  int? containerId;
  String medicineName;
  List<int> dosage;
  int? medicineLeft;
  bool isActive;
  bool isAlert;
  String? note;
  ReminderType type;
  List<Time> times;
  List<Days>? daysofWeek;
  DateTime? endDate;

  Reminder({
    this.id,
    this.deviceId,
    this.userId,
    this.containerId,
    required this.medicineName,
    required this.dosage,
    this.medicineLeft,
    this.isActive = true,
    this.isAlert = false,
    this.note,
    required this.type,
    required this.times,
    this.daysofWeek,
    this.endDate,
  });

  Reminder copyWith({
    int? id,
    int? deviceId,
    int? userId,
    int? containerId,
    String? medicineName,
    List<int>? dosage,
    int? medicineLeft,
    bool? isActive,
    bool? isAlert,
    String? note,
    ReminderType? type,
    List<Time>? times,
    List<Days>? daysofWeek,
    DateTime? endDate,
  }) {
    return Reminder(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      containerId: containerId ?? this.containerId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      medicineLeft: medicineLeft ?? this.medicineLeft,
      isActive: isActive ?? this.isActive,
      isAlert: isAlert ?? this.isAlert,
      note: note ?? this.note,
      type: type ?? this.type,
      times: times ?? this.times,
      daysofWeek: daysofWeek ?? this.daysofWeek,
      endDate: endDate ?? this.endDate,
    );
  }
}

enum ReminderType {
  onceDaily,
  twiceDaily,
  multipleTimesDaily,
  intervalhours,
  intervaldays,
  specificDays,
  cyclic,
}

enum Days {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
