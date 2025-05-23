import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/device/domain/entities/container.dart';

class DeviceModel extends Device {
  const DeviceModel({
    super.id,
    required super.uuid,
    required super.currentState,
    super.temperature,
    super.humidity,
    required super.containers,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        id: json['id'],
        uuid: json['uuid'],
        currentState: json['current_state'],
        temperature: json['temperature'],
        humidity: json['humidity'],
        containers: (json['containers'] as List)
            .map((x) => ContainerModel.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'current_state': currentState,
        'temperature': temperature,
        'humidity': humidity,
        'containers':
            containers.map((x) => (x as ContainerModel).toJson()).toList(),
      };
}

class ContainerModel extends DeviceContainer {
  const ContainerModel({
    int? id,
    required int deviceId,
    required int containerId,
    String? medicineName,
    int? quantity,
  }) : super(
          id: id,
          deviceId: deviceId,
          containerId: containerId,
          medicineName: medicineName,
          quantity: quantity,
        );

  factory ContainerModel.fromJson(Map<String, dynamic> json) => ContainerModel(
        id: json['id'],
        deviceId: json['device_id'],
        containerId: json['container_id'],
        medicineName: json['medicine_name'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'device_id': deviceId,
        'container_id': containerId,
        'medicine_name': medicineName,
        'quantity': quantity,
      };
}
