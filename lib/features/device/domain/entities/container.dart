// Container entity for clean architecture
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'containerId': containerId,
      'medicineName': medicineName,
      'quantity': quantity,
    };
  }

  static Future<DeviceContainer> fromModel(DeviceContainer container) {
    if (container.id == null) {
      return Future.value(null);
    }
    return Future.value(
      DeviceContainer(
        id: container.id,
        deviceId: container.deviceId,
        containerId: container.containerId,
        medicineName: container.medicineName,
        quantity: container.quantity,
      ),
    );
  }

  @override
  List<Object?> get props =>
      [id, deviceId, containerId, medicineName, quantity];
}
