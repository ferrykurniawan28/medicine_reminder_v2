// Device entity for clean architecture
import 'package:equatable/equatable.dart';
import 'container.dart';

class Device extends Equatable {
  final int? id;
  final String uuid;
  final int currentState;
  final int? temperature;
  final int? humidity;
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
    int? temperature,
    int? humidity,
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

  @override
  List<Object?> get props =>
      [id, uuid, currentState, temperature, humidity, containers];
}
