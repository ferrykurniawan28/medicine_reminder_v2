import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/user/data/models/user_model.dart';

class DeviceControlModel extends Equatable {
  final int id;
  final String action;
  final int containerId;
  final int deviceId;
  final String? medicineName;
  final String? notes;
  final int? quantity;
  final UserModel requestedBy;
  final String status;

  const DeviceControlModel({
    required this.id,
    required this.action,
    required this.containerId,
    required this.deviceId,
    this.medicineName,
    this.notes,
    this.quantity,
    required this.requestedBy,
    required this.status,
  });

  factory DeviceControlModel.fromJson(Map<String, dynamic> json) {
    return DeviceControlModel(
      id: json['id'],
      action: json['action'],
      containerId: json['container_id'],
      deviceId: json['device_id'],
      medicineName: json['medicine_name'],
      notes: json['notes'],
      quantity: json['quantity'],
      requestedBy: UserModel.fromJson(json['requested_by']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'container_id': containerId,
      'device_id': deviceId,
      'medicine_name': medicineName,
      'notes': notes,
      'quantity': quantity,
      'requested_by': requestedBy,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        action,
        containerId,
        deviceId,
        medicineName,
        notes,
        quantity,
        requestedBy,
        status
      ];
}
