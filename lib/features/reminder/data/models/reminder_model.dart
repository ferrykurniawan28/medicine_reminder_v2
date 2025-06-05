import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';

class ReminderModel extends Reminder {
  final int isSynced;

  ReminderModel({
    super.id,
    super.deviceId,
    super.createdBy,
    super.assignedTo,
    super.containerId,
    required super.medicineName,
    required super.dosage,
    super.medicineLeft,
    super.isActive,
    super.isAlert,
    super.note,
    required super.type,
    required super.times,
    super.daysofWeek,
    super.endDate,
    this.isSynced = 0,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as int?,
      deviceId: json['deviceId'] as int?,
      createdBy: json['createdBy'] as int?,
      assignedTo: json['assignedTo'] as int?,
      containerId: json['containerId'] as int?,
      medicineName: json['medicineName'] as String,
      dosage: (json['dosage'] as List).map((e) => e as int).toList(),
      medicineLeft: json['medicineLeft'] as int?,
      isActive: json['isActive'] as bool,
      isAlert: json['isAlert'] as bool? ?? false,
      note: json['note'] as String?,
      type: ReminderType.values[json['type'] as int],
      times: (json['times'] as List<dynamic>)
          .map((e) => Time.fromDateTime(DateTime.parse(e)))
          .toList(),
      daysofWeek: (json['daysofWeek'] as List<dynamic>?)
          ?.map((e) => Days.values[e])
          .toList(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      isSynced: json['is_synced'] is int
          ? json['is_synced'] ?? 0
          : int.tryParse(json['is_synced']?.toString() ?? '0') ?? 0,
    );
  }

  @override
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
      'type': ReminderTypeHelper.getName(type),
      'times': times
          .map((t) => DateTime(0, 1, 1, t.hour, t.minute).toIso8601String())
          .toList(),
      'daysofWeek': daysofWeek?.map((e) => e.index).toList(),
      'endDate': endDate?.toIso8601String(),
      'is_synced': isSynced,
    };
  }
}

// enum ReminderType {
//   onceDaily,
//   twiceDaily,
//   multipleTimesDaily,
//   intervalhours,
//   intervaldays,
//   specificDays,
//   cyclic,
// }

// enum Days {
//   monday,
//   tuesday,
//   wednesday,
//   thursday,
//   friday,
//   saturday,
//   sunday,
// }

class ReminderTypeHelper {
  static String getName(ReminderType type) {
    switch (type) {
      case ReminderType.onceDaily:
        return 'Once Daily';
      case ReminderType.twiceDaily:
        return 'Twice Daily';
      case ReminderType.multipleTimesDaily:
        return 'Multiple Times Daily';
      case ReminderType.intervalhours:
        return 'Interval Hours';
      case ReminderType.intervaldays:
        return 'Interval Days';
      case ReminderType.specificDays:
        return 'Specific Days';
      case ReminderType.cyclic:
        return 'Cyclic';
    }
  }
}

class ReminderDayHelper {
  static String getName(Days day) {
    switch (day) {
      case Days.monday:
        return 'Monday';
      case Days.tuesday:
        return 'Tuesday';
      case Days.wednesday:
        return 'Wednesday';
      case Days.thursday:
        return 'Thursday';
      case Days.friday:
        return 'Friday';
      case Days.saturday:
        return 'Saturday';
      case Days.sunday:
        return 'Sunday';
    }
  }
}

List<ReminderModel> dummyReminders = [
  ReminderModel(
    id: 1,
    deviceId: 1,
    createdBy: 1,
    assignedTo: 1,
    containerId: 1,
    medicineName: 'Paracetamol',
    dosage: [1],
    medicineLeft: 10,
    isActive: true,
    note: 'Take medication',
    type: ReminderType.onceDaily,
    times: const [
      Time(
        9,
        0,
      ),
    ],
    daysofWeek: null,
    endDate: DateTime.now().add(const Duration(days: 30)),
  ),
  ReminderModel(
    id: 2,
    deviceId: 1,
    createdBy: 1,
    assignedTo: 1,
    containerId: 1,
    medicineName: 'Ibuprofen',
    dosage: [2],
    medicineLeft: 5,
    isActive: false,
    note: 'Check blood pressure',
    type: ReminderType.twiceDaily,
    times: const [
      Time(
        8,
        0,
      ),
      Time(
        18,
        0,
      ),
    ],
    daysofWeek: null,
    endDate: DateTime.now().add(const Duration(days: 15)),
  ),
];
