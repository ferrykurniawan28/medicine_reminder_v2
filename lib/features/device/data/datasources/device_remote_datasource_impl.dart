import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'device_remote_datasource.dart';

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final NetworkService networkService;

  DeviceRemoteDataSourceImpl(this.networkService);

  @override
  Future<DeviceModel> fetchDevice(int userId) async {
    print('Fetching remote devices for user ID: $userId');
    final response = await networkService.get('$deviceUserUrl/$userId');
    if (response.statusCode == 200) {
      final devicesJson = response.data;
      if (devicesJson.isNotEmpty) {
        return DeviceModel.fromJson(devicesJson);
      } else {
        throw Exception('No devices found for user ID: $userId');
      }
    } else {
      throw Exception('Failed to fetch devices: ${response.statusCode}');
    }
  }

  @override
  Future<DeviceModel> addDevice(int userId, String deviceUid) async {
    final body = {
      'user_id': userId,
      'device_uid': deviceUid,
    };
    final response = await networkService.post(deviceRegisterUrl, body: body);
    if (response.statusCode != 201) {
      throw Exception('Failed to add device: ${response.statusCode}');
    }
    print('response: ${response.data}');
    if (response.data == null) {
      throw Exception('No device data returned from add device request');
    }

    final device = DeviceModel.fromJson(response.data);
    print('Device added successfully: ${device.toJson()}');
    if (device.id == null) {
      throw Exception('Device ID is null after adding device');
    }

    return device;
  }

  @override
  Future<void> updateDevice(DeviceModel device) async {
    final response = await networkService.put('$deviceUserUrl/${device.id}',
        body: device.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update device: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteDevice(int deviceId) async {
    final response = await networkService.delete('$deviceUserUrl/$deviceId');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete device: ${response.statusCode}');
    }
  }
}
