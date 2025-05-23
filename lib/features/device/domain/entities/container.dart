// Container entity for clean architecture
import 'package:equatable/equatable.dart';

class DeviceContainer extends Equatable {
  final int? id;
  final int deviceId;
  final int containerId;
  final String? medicineName;
  final int? quantity;

  const DeviceContainer({
    this.id,
    required this.deviceId,
    required this.containerId,
    this.medicineName,
    this.quantity,
  });

  DeviceContainer copyWith({
    int? id,
    int? deviceId,
    int? containerId,
    String? medicineName,
    int? quantity,
  }) {
    return DeviceContainer(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      containerId: containerId ?? this.containerId,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props =>
      [id, deviceId, containerId, medicineName, quantity];
}
