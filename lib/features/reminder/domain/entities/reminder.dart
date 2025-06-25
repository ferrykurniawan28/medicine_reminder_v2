import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class Reminder {
  final int? id;
  int? deviceId;
  final User? createdBy;
  final User? assignedTo;
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

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as int?,
      deviceId: json['deviceId'] as int?,
      createdBy: User.fromJson(json['createdBy']),
      assignedTo: User.fromJson(json['assignedTo']),
      containerId: json['containerId'] as int?,
      medicineName: json['medicineName'] as String,
      dosage: (json['dosage'] as String)
          .split(',')
          .map((v) => int.tryParse(v) ?? 0)
          .toList(),
      medicineLeft: json['medicineLeft'] as int?,
      isActive: json['isActive'] == 1,
      isAlert: json['isAlert'] == 1,
      note: json['note'] as String?,
      type: ReminderType.values[json['type'] as int],
      times: (json['times'] as String)
          .split(';')
          .map((v) => Time.fromString(v))
          .toList(),
      daysofWeek: (json['daysofWeek'] as String?)
          ?.split(',')
          .map((v) => Days.values[int.parse(v)])
          .toList(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Reminder copyWith({
    int? id,
    int? deviceId,
    User? createdBy,
    User? assignedTo,
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
      'createdBy': createdBy?.toJson(), // Serialize createdBy
      'assignedTo': assignedTo?.toJson(), // Serialize assignedTo
      'containerId': containerId,
      'medicineName': medicineName,
      'dosage': dosage.join(','),
      'medicineLeft': medicineLeft,
      'isActive': isActive ? 1 : 0,
      'isAlert': isAlert ? 1 : 0,
      'note': note,
      'type': type.index,
      'times': times.map((t) => t.toString()).join(';'),
      'daysofWeek': daysofWeek?.map((d) => d.index).join(','),
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
