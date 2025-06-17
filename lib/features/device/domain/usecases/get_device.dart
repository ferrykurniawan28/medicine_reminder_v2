import '../entities/device.dart';
import '../repositories/device_repository.dart';

class GetDevice {
  final DeviceRepository repository;
  GetDevice(this.repository);
  Future<Device?> call(int deviceId) => repository.getDevice(deviceId);
}
