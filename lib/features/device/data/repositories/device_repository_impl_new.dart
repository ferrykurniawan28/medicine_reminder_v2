import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_remote_datasource.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/container.dart';
import 'package:medicine_reminder/features/device/domain/entities/device_control.dart';
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

  @override
  Future<Device> addDevice(int userId, String deviceUid) async {
    // Only allow device modifications when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('Device modifications require internet connection');
    }

    try {
      // Add the device to the remote database
      final device = await remoteDataSource.addDevice(userId, deviceUid);
      // Cache locally after successful remote add
      await localDataSource.addDevice(device);
      if (device.id != null) {
        await localDataSource.addUserDevice(userId, device.id!);
        return Device.fromModel(device);
      } else {
        throw Exception('Device ID is null');
      }
    } catch (e) {
      print('Error adding device: $e');
      rethrow;
    }
  }

  @override
  Future<Device?> getDevice(int userId) async {
    // Try remote first if online, fallback to local
    if (isOnline != null && isOnline!()) {
      try {
        final remoteDevice = await remoteDataSource.fetchDevice(userId);
        // Cache the fetched device locally
        await localDataSource.addDevice(remoteDevice);
        if (remoteDevice.id != null) {
          await localDataSource.addUserDevice(userId, remoteDevice.id!);
        }
        return Device.fromModel(remoteDevice);
      } catch (e) {
        print('Error fetching remote device, using local cache: $e');
        // Fallback to local cache
      }
    }

    // Read from local cache (offline or remote failed)
    final deviceId = await localDataSource.getDeviceIdByUserId(userId);
    if (deviceId != null) {
      final localDevice = await localDataSource.getDevice(deviceId);
      return Device.fromModel(localDevice);
    }
    return null;
  }

  @override
  Future<void> updateContainer(int userId, DeviceContainer container) async {
    // Only allow container modifications when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('Container modifications require internet connection');
    }

    try {
      final containerModel = ContainerModel(
        id: container.id,
        deviceId: container.deviceId,
        containerId: container.containerId,
        medicineName: container.medicineName,
        quantity: container.quantity,
      );
      await remoteDataSource.updateContainer(userId, containerModel);
      // TODO: Update local cache after successful remote update
      // await localDataSource.updateContainer(containerModel);
    } catch (e) {
      print('Error updating container: $e');
      rethrow;
    }
  }

  @override
  Future<void> resetContainer(int userId, int containerId) async {
    // Only allow container reset when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('Container reset requires internet connection');
    }

    try {
      await remoteDataSource.resetContainer(userId, containerId);
      // TODO: Update local cache after successful remote reset
      // await localDataSource.resetContainer(containerId);
    } catch (e) {
      print('Error resetting container: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteDevice(int userId, int deviceId) async {
    // Only allow device deletion when online
    if (isOnline == null || !isOnline!()) {
      throw Exception('Device deletion requires internet connection');
    }

    try {
      await remoteDataSource.deleteDevice(deviceId);
      // Remove from local cache after successful remote deletion
      await localDataSource.deleteDevice(deviceId);
      await localDataSource.deleteUserDevice(userId);
    } catch (e) {
      print('Error deleting device: $e');
      rethrow;
    }
  }

  @override
  Future<int> getDeviceControlCount(int deviceId) async {
    // Try remote first if online, fallback to local
    if (isOnline != null && isOnline!()) {
      try {
        final count = await remoteDataSource.getDeviceControlCount(deviceId);
        return count;
      } catch (e) {
        print('Error fetching remote device control count, using local: $e');
      }
    }

    // Fallback to local cache
    return await localDataSource.getDeviceControlCount(deviceId);
  }

  @override
  Future<List<DeviceControl>?> getDeviceControl(int deviceId) async {
    // Try remote first if online, fallback to local
    if (isOnline != null && isOnline!()) {
      try {
        final remoteControls =
            await remoteDataSource.fetchDeviceControl(deviceId);
        // TODO: Cache controls locally
        // for (var control in remoteControls) {
        //   await localDataSource.cacheDeviceControl(control);
        // }
        return remoteControls
            .map((control) => DeviceControl.fromModel(control))
            .toList();
      } catch (e) {
        print('Error fetching remote device controls, using local: $e');
      }
    }

    // Fallback to local cache
    final localControls = await localDataSource.getDeviceControls(deviceId);
    return localControls
        ?.map((control) => DeviceControl.fromModel(control))
        .toList();
  }
}
