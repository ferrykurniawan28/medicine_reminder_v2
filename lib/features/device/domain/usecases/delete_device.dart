import '../repositories/device_repository.dart';

class DeleteDevice {
  final DeviceRepository repository;
  DeleteDevice(this.repository);
  Future<void> call(int deviceId) => repository.deleteDevice(deviceId);
}
