import '../repositories/device_repository.dart';

class ContainerReset {
  final DeviceRepository repository;

  ContainerReset(this.repository);

  Future<void> call(int userId, int containerId) async {
    await repository.resetContainer(userId, containerId);
  }
}
