import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';

class Reminder {
  final int? id;
  int? deviceId;
  final int? createdBy;
  final int? assignedTo;
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
    this.createdBy,
    this.assignedTo,
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
    int? createdBy,
    int? assignedTo,
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
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'containerId': containerId,
      'medicineName': medicineName,
      'dosage': dosage,
      'medicineLeft': medicineLeft,
      'isActive': isActive,
      'isAlert': isAlert,
      'note': note,
      'type': type.index,
      'times': times
          .map((t) => DateTime(0, 1, 1, t.hour, t.minute).toIso8601String())
          .toList(),
      'daysofWeek': daysofWeek?.map((e) => e.index).toList(),
      'endDate': endDate?.toIso8601String(),
    };
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
