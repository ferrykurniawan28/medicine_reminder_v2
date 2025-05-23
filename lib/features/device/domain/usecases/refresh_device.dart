import '../repositories/device_repository.dart';

class RefreshDevice {
  final DeviceRepository repository;
  RefreshDevice(this.repository);
  Future<void> call() => repository.refreshDevice();
}
