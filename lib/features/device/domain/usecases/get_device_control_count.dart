import '../repositories/device_repository.dart';

class GetDeviceControlCount {
  final DeviceRepository repository;

  GetDeviceControlCount(this.repository);

  Future<int> call(int deviceId) async {
    return await repository.getDeviceControlCount(deviceId);
  }
}
