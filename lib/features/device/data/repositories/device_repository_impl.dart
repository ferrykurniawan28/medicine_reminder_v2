import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_remote_datasource.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/repositories/device_repository.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceLocalDataSource localDataSource;
  final DeviceRemoteDataSource remoteDataSource;
  final bool Function()? isOnline;

  DeviceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    this.isOnline,
  });

  // @override
  // Future<DeviceModel> getDevices(int userId) async {
  //   if (isOnline != null && isOnline!()) {
  //     try {
  //       final remoteDevice = await remoteDataSource.fetchDevice(userId);
  //       await localDataSource.addDevice(remoteDevice);
  //       return remoteDevice;
  //     } catch (_) {
  //       return await localDataSource.getDevice(userId);
  //     }
  //   } else {
  //     return await localDataSource.getDevice(userId);
  //   }
  // }

  @override
  Future<Device> addDevice(int userId, String deviceUid) async {
    if (isOnline != null && isOnline!()) {
      try {
        // Add the device to the remote database
        final device = await remoteDataSource.addDevice(userId, deviceUid);

        // Add the device to the local database
        await localDataSource.addDevice(device);

        // Associate the device with the user in the local database
        if (device.id != null) {
          await localDataSource.addUserDevice(userId, device.id!);
          return Device.fromModel(device);
        } else {
          // If the device does not have an ID, we cannot store it locally
          // or associate it with the user.
          throw Exception('Device ID is null');
        }
      } catch (e) {
        // Handle any errors that occur during the process
        print('Error adding device: $e');
        rethrow;
      }
    } else {
      throw Exception('Cannot add device while offline');
    }
  }

  @override
  Future<Device?> getDevice(int userId) async {
    if (isOnline != null && isOnline!()) {
      try {
        final remoteDevice = await remoteDataSource.fetchDevice(userId);
        await localDataSource.addDevice(remoteDevice);
        if (remoteDevice.id != null) {
          await localDataSource.addUserDevice(userId, remoteDevice.id!);
        } else {
          // If the remote device does not have an ID, we cannot store it locally
          // or associate it with the user.
          return null;
        }
        return Device.fromModel(remoteDevice);
      } catch (_) {
        final deviceId = await localDataSource.getDeviceIdByUserId(userId);
        if (deviceId != null) {
          final localDevice = await localDataSource.getDevice(deviceId);
          return Device.fromModel(localDevice);
        }
        return null;
      }
    } else {
      final deviceId = await localDataSource.getDeviceIdByUserId(userId);
      if (deviceId != null) {
        final localDevice = await localDataSource.getDevice(deviceId);
        return Device.fromModel(localDevice);
      }
      return null;
    }
  }

  @override
  Future<void> updateDevice(Device device) async {
    final deviceModel = DeviceModel(
      id: device.id,
      uuid: device.uuid,
      currentState: device.currentState,
      temperature: device.temperature,
      humidity: device.humidity,
      containers: device.containers
          .map((container) => ContainerModel(
                id: container.id,
                deviceId: container.deviceId,
                containerId: container.containerId,
                medicineName: container.medicineName,
                quantity: container.quantity,
              ))
          .toList(),
    );
    await localDataSource.updateDevice(deviceModel);
    if (isOnline != null && isOnline!()) {
      await remoteDataSource.updateDevice(deviceModel);
    }
  }

  @override
  Future<void> deleteDevice(int deviceId) async {
    await localDataSource.deleteDevice(deviceId);
    if (isOnline != null && isOnline!()) {
      await remoteDataSource.deleteDevice(deviceId);
    }
  }
}
