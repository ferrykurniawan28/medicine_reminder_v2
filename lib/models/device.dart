part of 'models.dart';

// class DeviceModel extends Equatable {
//   final int? id;
//   final String uuid;
//   final int currentState;
//   final int? temperature;
//   final int? humidity;
//   final List<ContainerModel> containers;

//   const DeviceModel({
//     this.id,
//     required this.uuid,
//     required this.currentState,
//     this.temperature,
//     this.humidity,
//     required this.containers,
//   });

//   factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
//         id: json['id'],
//         uuid: json['uuid'],
//         currentState: json['current_state'],
//         temperature: json['temperature'],
//         humidity: json['humidity'],
//         containers: List<ContainerModel>.from(
//             json['containers'].map((x) => ContainerModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'uuid': uuid,
//         'current_state': currentState,
//         'temperature': temperature,
//         'humidity': humidity,
//         'containers': List<dynamic>.from(containers.map((x) => x.toJson())),
//       };

//   DeviceModel copyWith({
//     int? id,
//     String? uuid,
//     int? currentState,
//     int? temperature,
//     int? humidity,
//     List<ContainerModel>? containers,
//   }) {
//     return DeviceModel(
//       id: id ?? this.id,
//       uuid: uuid ?? this.uuid,
//       currentState: currentState ?? this.currentState,
//       temperature: temperature ?? this.temperature,
//       humidity: humidity ?? this.humidity,
//       containers: containers ?? this.containers,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is DeviceModel &&
//         other.id == id &&
//         other.uuid == uuid &&
//         other.currentState == currentState &&
//         other.temperature == temperature &&
//         other.humidity == humidity &&
//         listEquals(other.containers, containers);
//   }

//   bool listEquals<T>(List<T>? a, List<T>? b) {
//     if (a == null) return b == null;
//     if (b == null || a.length != b.length) return false;
//     for (int i = 0; i < a.length; i++) {
//       if (a[i] != b[i]) return false;
//     }
//     return true;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         uuid.hashCode ^
//         currentState.hashCode ^
//         temperature.hashCode ^
//         humidity.hashCode ^
//         containers.hashCode;
//   }

//   @override
//   List<Object?> get props =>
//       [id, uuid, currentState, temperature, humidity, containers];
// }

// DeviceModel dummyDevice = DeviceModel(
//   id: 1,
//   uuid: '123e4567-e89b-12d3-a456-426614174000',
//   currentState: 1,
//   temperature: 25,
//   humidity: 60,
//   containers: List.generate(
//       5,
//       (index) => ContainerModel(
//             id: index,
//             deviceId: 1,
//             containerId: index + 1,
//             medicineName: null,
//             quantity: null,
//           )),
// );
