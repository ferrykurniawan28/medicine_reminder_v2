part of 'device_bloc.dart';

@immutable
sealed class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

final class DeviceFetch extends DeviceEvent {
  final int userId;

  const DeviceFetch(this.userId);

  @override
  List<Object> get props => [userId];
}

final class LoadDeviceDetail extends DeviceEvent {
  final Device device;

  const LoadDeviceDetail(this.device);

  @override
  List<Object> get props => [device];
}

final class DeviceRefresh extends DeviceEvent {}

final class DeviceUpdate extends DeviceEvent {
  final Device device;

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

final class DeviceAdd extends DeviceEvent {
  final int userId;
  final String deviceUid;

  const DeviceAdd(this.userId, this.deviceUid);

  @override
  List<Object> get props => [userId, deviceUid];
}
