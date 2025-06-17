import '../entities/device.dart';
import '../repositories/device_repository.dart';

class GetDevices {
  final DeviceRepository repository;
  GetDevices(this.repository);
  Future<Device?> call(int userId) => repository.getDevice(userId);
}
