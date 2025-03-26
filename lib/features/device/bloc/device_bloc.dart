import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/device/models/models.dart';
import 'package:meta/meta.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceModel? _device;
  List<DeviceModel> _devices = [];
  DeviceBloc() : super(DeviceInitial()) {
    on<DevicesFetch>(_onFetchDevices);
    on<DeviceFetch>(_onFetchDevice);
    on<DeviceRefresh>(_onRefreshDevices);
    on<LoadDeviceDetail>(_onLoadDevice);
    on<DeviceUpdate>(_onDeviceUpdate);
    on<UpdateContainer>(_onUpdateContainer);
    on<ResetContainer>(_onResetContainer);
  }

  Future<void> _onFetchDevices(
      DevicesFetch event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      _devices = dummyDevice;
      // final devices = await _deviceRepository.getDevice(event.deviceId);
      emit(DevicesLoaded(_devices));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onFetchDevice(
      DeviceFetch event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      final device =
          _devices.firstWhere((element) => element.id == event.deviceId);
      // final device = await _deviceRepository.getDevice(event.deviceId);
      emit(DeviceLoaded(device));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onRefreshDevices(
      DeviceRefresh event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      Future.delayed(const Duration(seconds: 2));
      final device = dummyDevice;
      // final device = await _deviceRepository.getDevice(event.deviceId);
      emit(DevicesLoaded(device));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onLoadDevice(LoadDeviceDetail event, Emitter<DeviceState> emit) {
    _device = event.device;
    emit(DeviceLoaded(_device!));
  }

  void _onDeviceUpdate(DeviceUpdate event, Emitter<DeviceState> emit) {
    _device = event.device;
    emit(DeviceLoaded(_device!));
  }

  void _onUpdateContainer(UpdateContainer event, Emitter<DeviceState> emit) {
    if (_device == null) {
      emit(const DeviceError('Device not loaded'));
      return;
    }

    final containerIndex = _device!.containers
        .indexWhere((element) => element.id == event.containerId);
    if (containerIndex == -1) {
      emit(const DeviceError('Container not found'));
      return;
    }

    final updatedContainer = _device!.containers[containerIndex].copyWith(
      medicineName: event.medicineName,
      quantity: event.quantity,
    );

    final updatedContainers = List<ContainerModel>.from(_device!.containers);
    updatedContainers[containerIndex] = updatedContainer;

    _device = _device!.copyWith(containers: updatedContainers);
    emit(ContainerUpdated(_device!));
  }

  void _onResetContainer(ResetContainer event, Emitter<DeviceState> emit) {
    if (_device == null) {
      emit(const DeviceError('Device not loaded'));
      return;
    }

    // Find and update in maintained devices list
    final deviceIndex = _devices.indexWhere((d) => d.id == _device!.id);
    if (deviceIndex == -1) {
      emit(const DeviceError('Device not found in maintained list'));
      return;
    }

    // Update the specific container
    final containerIndex = _devices[deviceIndex]
        .containers
        .indexWhere((c) => c.containerId == event.containerId);
    if (containerIndex == -1) {
      emit(const DeviceError('Container not found'));
      return;
    }

    // Create new containers list
    final updatedContainers = List<ContainerModel>.from(
      _devices[deviceIndex].containers,
    );

    updatedContainers[containerIndex] =
        updatedContainers[containerIndex].copyWith(
      medicineName: null,
      quantity: null,
    );

    // Create new device with updated containers
    final updatedDevice = _devices[deviceIndex].copyWith(
      containers: updatedContainers,
    );

    // Update both local references
    _devices[deviceIndex] = updatedDevice;
    _device = updatedDevice;

    emit(DeviceLoaded(updatedDevice));
  }
}
