part of 'device_bloc.dart';

@immutable
sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

final class DeviceInitial extends DeviceState {}

final class DeviceListLoading extends DeviceState {}

final class DeviceLoading extends DeviceState {}

final class DevicesLoaded extends DeviceState {
  final List<DeviceModel> devices;

  const DevicesLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

final class DeviceLoaded extends DeviceState {
  final DeviceModel device;

  const DeviceLoaded(this.device);

  @override
  List<Object> get props => [device];
}

final class ContainerUpdated extends DeviceState {
  final DeviceModel device;

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
