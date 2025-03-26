part of 'device_bloc.dart';

@immutable
sealed class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

final class DevicesFetch extends DeviceEvent {
  final int userId;

  const DevicesFetch(this.userId);

  @override
  List<Object> get props => [userId];
}

final class DeviceFetch extends DeviceEvent {
  final int deviceId;

  const DeviceFetch(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

final class LoadDevice extends DeviceEvent {
  final List<DeviceModel> devices;

  const LoadDevice(this.devices);

  @override
  List<Object> get props => [devices];
}

final class LoadDeviceDetail extends DeviceEvent {
  final DeviceModel device;

  const LoadDeviceDetail(this.device);

  @override
  List<Object> get props => [device];
}

final class DeviceRefresh extends DeviceEvent {}

final class DeviceUpdate extends DeviceEvent {
  final DeviceModel device;

  const DeviceUpdate(this.device);

  @override
  List<Object> get props => [device];
}

final class DeviceDelete extends DeviceEvent {
  final String deviceId;

  const DeviceDelete(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

final class UpdateContainer extends DeviceEvent {
  final int containerId;
  final String? medicineName;
  final int? quantity;

  const UpdateContainer({
    required this.containerId,
    this.medicineName,
    this.quantity,
  });

  @override
  List<Object> get props => [containerId, medicineName ?? '', quantity ?? 0];
}

final class ResetContainer extends DeviceEvent {
  final int containerId;

  const ResetContainer(this.containerId);

  @override
  List<Object> get props => [containerId];
}
