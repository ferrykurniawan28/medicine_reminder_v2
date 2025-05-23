import '../repositories/device_repository.dart';

class DeleteDevice {
  final DeviceRepository repository;
  DeleteDevice(this.repository);
  Future<void> call() => repository.deleteDevice();
}
