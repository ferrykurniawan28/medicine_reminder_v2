import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_datasource.dart';
import '../models/device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceLocalDataSource localDataSource;
  DeviceRepositoryImpl(this.localDataSource);

  @override
  Future<Device?> getDevice(int id) async {
    return await localDataSource.getDevice(id);
  }

  @override
  Future<List<Device>> getDevices() async {
    return await localDataSource.getDevices();
  }

  @override
  Future<void> updateDevice(Device device) async {
    await localDataSource.updateDevice(device as DeviceModel);
  }

  @override
  Future<void> refreshDevice() async {
    await localDataSource.refreshDevice();
  }

  @override
  Future<void> deleteDevice() async {
    await localDataSource.deleteDevice();
  }
}
