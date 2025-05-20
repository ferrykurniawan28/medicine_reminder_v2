// This file has been moved to lib/features/reminder/data/models/reminder_model.dart as ReminderModel.
// Please update your imports to use the new location and class name.

// part of 'models.dart';

// class Reminder {
//   final int? id;
//   final int? deviceId;
//   final int? userId;
//   final int? containerId;
//   final String medicineName;
//   final List<int> dosage;
//   final int? medicineLeft;
//   bool isActive;
//   bool isAlert;
//   final String? note;
//   final ReminderType type;
//   final List<TimeOfDay> times;
//   final List<Days>? daysofWeek;
//   final DateTime? endDate;

//   Reminder({
//     this.id,
//     this.deviceId,
//     this.userId,
//     this.containerId,
//     this.isActive = true,
//     this.isAlert = false,
//     required this.medicineName,
//     required this.dosage,
//     this.medicineLeft,
//     this.note,
//     required this.type,
//     required this.times,
//     this.daysofWeek,
//     this.endDate,
//   });

//   factory Reminder.fromJson(Map<String, dynamic> json) {
//     return Reminder(
//       id: json['id'] as int?,
//       deviceId: json['deviceId'] as int?,
//       userId: json['userId'] as int?,
//       containerId: json['containerId'] as int?,
//       medicineName: json['medicineName'] as String,
//       dosage: (json['dosage'] as List<dynamic>).map((e) => e as int).toList(),
//       medicineLeft: json['medicineLeft'] as int?,
//       isActive: json['isActive'] as bool,
//       isAlert: json['isAlert'] as bool? ?? false,
//       note: json['note'] as String?,
//       type: ReminderType.values[json['type'] as int],
//       times: (json['times'] as List<dynamic>?)!
//           .map((e) => TimeOfDay.fromDateTime(DateTime.parse(e)))
//           .toList(),
//       daysofWeek: (json['daysofWeek'] as List<dynamic>?)
//           ?.map((e) => Days.values[e])
//           .toList(),
//       endDate: DateTime.tryParse(json['endDate'] as String),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'deviceId': deviceId,
//       'userId': userId,
//       'containerId': containerId,
//       'medicineName': medicineName,
//       'dosage': dosage,
//       'medicineLeft': medicineLeft,
//       'isActive': isActive,
//       'isAlert': isAlert,
//       'note': note,
//       'type': type.index,
//       'times': times.map((e) => e.toString()).toList(),
//       'daysofWeek': daysofWeek?.map((e) => e.index).toList(),
//       'endDate': endDate?.toIso8601String(),
//     };
//   }

//   Reminder copyWith({
//     int? id,
//     int? deviceId,
//     int? userId,
//     int? containerId,
//     String? medicineName,
//     List<int>? dosage,
//     int? medicineLeft,
//     bool? isActive,
//     bool? isAlert,
//     String? note,
//     ReminderType? type,
//     List<TimeOfDay>? times,
//     List<Days>? daysofWeek,
//     DateTime? endDate,
//     bool deleteNote = false,
//     bool deleteDaysofWeek = false,
//     bool deleteTimes = false,
//     bool deleteEndDate = false,
//     bool deleteMedicineLeft = false,
//     bool deleteDosage = false,
//     bool deleteContainerId = false,
//     bool deleteUserId = false,
//     bool deleteDeviceId = false,
//   }) {
//     return Reminder(
//       id: id ?? this.id,
//       deviceId: deleteDeviceId ? null : deviceId ?? this.deviceId,
//       userId: deleteUserId ? null : userId ?? this.userId,
//       containerId: deleteContainerId ? null : containerId ?? this.containerId,
//       medicineName: medicineName ?? this.medicineName,
//       dosage: deleteDosage ? [] : dosage ?? this.dosage,
//       medicineLeft:
//           deleteMedicineLeft ? null : medicineLeft ?? this.medicineLeft,
//       isActive: isActive ?? this.isActive,
//       isAlert: isAlert ?? this.isAlert,
//       note: deleteNote ? null : note ?? this.note,
//       type: type ?? this.type,
//       times: deleteTimes ? [] : times ?? this.times,
//       daysofWeek: deleteDaysofWeek ? [] : daysofWeek ?? this.daysofWeek,
//       endDate: deleteEndDate ? null : endDate ?? this.endDate,
//     );
//   }
// }

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

// class ReminderTypeHelper {
//   static String getName(ReminderType type) {
//     switch (type) {
//       case ReminderType.onceDaily:
//         return 'Once Daily';
//       case ReminderType.twiceDaily:
//         return 'Twice Daily';
//       case ReminderType.multipleTimesDaily:
//         return 'Multiple Times Daily';
//       case ReminderType.intervalhours:
//         return 'Interval Hours';
//       case ReminderType.intervaldays:
//         return 'Interval Days';
//       case ReminderType.specificDays:
//         return 'Specific Days';
//       case ReminderType.cyclic:
//         return 'Cyclic';
//     }
//   }
// }

// class ReminderDayHelper {
//   static String getName(Days day) {
//     switch (day) {
//       case Days.monday:
//         return 'Monday';
//       case Days.tuesday:
//         return 'Tuesday';
//       case Days.wednesday:
//         return 'Wednesday';
//       case Days.thursday:
//         return 'Thursday';
//       case Days.friday:
//         return 'Friday';
//       case Days.saturday:
//         return 'Saturday';
//       case Days.sunday:
//         return 'Sunday';
//     }
//   }
// }

// List<Reminder> dummyReminders = [
//   Reminder(
//     id: 1,
//     deviceId: 1,
//     userId: 1,
//     containerId: 1,
//     medicineName: 'Paracetamol',
//     dosage: [1],
//     medicineLeft: 10,
//     isActive: true,
//     note: 'Take medication',
//     type: ReminderType.onceDaily,
//     times: [const TimeOfDay(hour: 8, minute: 0)],
//     daysofWeek: null,
//     endDate: DateTime.now().add(const Duration(days: 30)),
//   ),
//   Reminder(
//     id: 2,
//     deviceId: 1,
//     userId: 1,
//     containerId: 1,
//     medicineName: 'Ibuprofen',
//     dosage: [2],
//     medicineLeft: 5,
//     isActive: false,
//     note: 'Check blood pressure',
//     type: ReminderType.twiceDaily,
//     times: const [
//       TimeOfDay(hour: 9, minute: 0),
//       TimeOfDay(hour: 18, minute: 0)
//     ],
//     daysofWeek: null,
//     endDate: DateTime.now().add(const Duration(days: 15)),
//   ),
// ];
