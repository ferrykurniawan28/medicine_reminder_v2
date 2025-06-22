import 'package:equatable/equatable.dart';

class DeviceControl extends Equatable {
  final int id;
  final String action;
  final int containerId;
  final int deviceId;
  final String medicineName;
  final String notes;
  final int quantity;
  final int requestedBy;
  final String status;

  const DeviceControl({
    required this.id,
    required this.action,
    required this.containerId,
    required this.deviceId,
    required this.medicineName,
    required this.notes,
    required this.quantity,
    required this.requestedBy,
    required this.status,
  });

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

  DeviceControl copyWith({
    int? id,
    String? action,
    int? containerId,
    int? deviceId,
    String? medicineName,
    String? notes,
    int? quantity,
    int? requestedBy,
    String? status,
  }) {
    return DeviceControl(
      id: id ?? this.id,
      action: action ?? this.action,
      containerId: containerId ?? this.containerId,
      deviceId: deviceId ?? this.deviceId,
      medicineName: medicineName ?? this.medicineName,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      requestedBy: requestedBy ?? this.requestedBy,
      status: status ?? this.status,
    );
  }
}
