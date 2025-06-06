part of 'models.dart';

// @immutable
// class ContainerModel extends Equatable {
//   final int? id;
//   final int deviceId;
//   final int containerId;
//   final String? medicineName;
//   final int? quantity;

//   const ContainerModel({
//     this.id,
//     required this.deviceId,
//     required this.containerId,
//     this.medicineName,
//     this.quantity,
//   });

//   factory ContainerModel.fromJson(Map<String, dynamic> json) => ContainerModel(
//         id: json['id'],
//         deviceId: json['device_id'],
//         containerId: json['container_id'],
//         medicineName: json['medicine_name'],
//         quantity: json['quantity'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'device_id': deviceId,
//         'container_id': containerId,
//         'medicine_name': medicineName,
//         'quantity': quantity,
//       };

//   ContainerModel copyWith({
//     int? id,
//     int? deviceId,
//     int? containerId,
//     String? medicineName,
//     int? quantity,
//   }) {
//     return ContainerModel(
//       id: id ?? this.id,
//       deviceId: deviceId ?? this.deviceId,
//       containerId: containerId ?? this.containerId,
//       medicineName: medicineName,
//       quantity: quantity,
//     );
//   }

//   @override
//   List<Object?> get props =>
//       [id, deviceId, containerId, medicineName, quantity];
// }
