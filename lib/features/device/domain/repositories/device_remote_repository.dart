abstract class DeviceRemoteRepository {
  Future<List<Map<String, dynamic>>> fetchDevices({int? userId});
  Future<void> addDevice(Map<String, dynamic> deviceJson);
  Future<void> updateDevice(int id, Map<String, dynamic> deviceJson);
  Future<void> deleteDevice(int id);
  Future<void> syncDevices(List<Map<String, dynamic>> devicesToSync);
}
