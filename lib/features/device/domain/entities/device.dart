// Device entity for clean architecture
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'container.dart';

class Device extends Equatable {
  final int? id;
  final String uuid;
  final int currentState;
  final double? temperature;
  final double? humidity;
  final List<DeviceContainer> containers;

  const Device({
    this.id,
    required this.uuid,
    required this.currentState,
    this.temperature,
    this.humidity,
    required this.containers,
  });

  Device copyWith({
    int? id,
    String? uuid,
    int? currentState,
    double? temperature,
    double? humidity,
    List<DeviceContainer>? containers,
  }) {
    return Device(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      currentState: currentState ?? this.currentState,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      containers: containers ?? this.containers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'currentState': currentState,
      'temperature': temperature,
      'humidity': humidity,
      'containers': containers.map((c) => c.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [id, uuid, currentState, temperature, humidity, containers];

  static Future<Device> fromModel(DeviceModel remoteDevice) async {
    if (remoteDevice.id == null) {
      throw Exception('DeviceModel ID is null, cannot convert to Device');
    }
    final containers = await Future.wait(
      remoteDevice.containers
          .map((container) => DeviceContainer.fromModel(container)),
    );
    return Device(
      id: remoteDevice.id,
      uuid: remoteDevice.uuid,
      currentState: remoteDevice.currentState,
      temperature: remoteDevice.temperature,
      humidity: remoteDevice.humidity,
      containers: containers,
    );
  }
}
