import '../entities/container.dart';
import '../repositories/device_repository.dart';

class ContainerUpdate {
  final DeviceRepository repository;

  ContainerUpdate(this.repository);

  Future<void> call(int userId, DeviceContainer container) async {
    await repository.updateContainer(userId, container);
  }
}
