import '../entities/device.dart';
import '../repositories/device_repository.dart';

class UpdateDevice {
  final DeviceRepository repository;
  UpdateDevice(this.repository);
  Future<void> call(Device device) => repository.updateDevice(device);
}
