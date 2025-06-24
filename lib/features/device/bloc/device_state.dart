part of 'device_bloc.dart';

@immutable
sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

final class DeviceInitial extends DeviceState {}

final class DeviceLoading extends DeviceState {}

final class DeviceLoaded extends DeviceState {
  final Device device;
  final int? deviceControlsCount;

  const DeviceLoaded(this.device, {this.deviceControlsCount});

  @override
  List<Object> get props =>
      [device, if (deviceControlsCount != null) deviceControlsCount!];
}

final class ContainerUpdated extends DeviceState {
  final Device device;

  const ContainerUpdated(this.device);

  @override
  List<Object> get props => [device];
}

final class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);

  @override
  List<Object> get props => [message];
}

final class DeviceControlLoaded extends DeviceState {
  final List<DeviceControl> deviceControls;

  const DeviceControlLoaded(this.deviceControls);

  @override
  List<Object> get props => [deviceControls];
}
