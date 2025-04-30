import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/models/models.dart';
import 'package:meta/meta.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceModel? device;

  DeviceBloc() : super(DeviceInitial()) {
    on<DeviceFetch>(_onFetchDevice);
    on<DeviceRefresh>(_onRefreshDevices);
    on<LoadDeviceDetail>(_onLoadDevice);
    on<DeviceUpdate>(_onDeviceUpdate);
    on<UpdateContainer>(_onUpdateContainer);
    on<ResetContainer>(_onResetContainer);
  }

  Future<void> _onFetchDevice(
      DeviceFetch event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      device = dummyDevice;
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));
      // device = await DeviceRepository().getDevice(event.deviceId);
      // Simulate a successful response

      emit(DeviceLoaded(device!));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onRefreshDevices(
      DeviceRefresh event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      // device = dummyDevice;
      if (device != null) {
        device = device;
      } else {
        device = dummyDevice;
      }
      emit(DeviceLoaded(device!));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onLoadDevice(LoadDeviceDetail event, Emitter<DeviceState> emit) {
    device = event.device;
    emit(DeviceLoaded(device!));
  }

  void _onDeviceUpdate(DeviceUpdate event, Emitter<DeviceState> emit) {
    device = event.device;
    emit(DeviceLoaded(device!));
  }

  Future<void> _onUpdateContainer(
      UpdateContainer event, Emitter<DeviceState> emit) async {
    try {
      if (device == null) {
        emit(const DeviceError('Device not loaded'));
      }

      final containerIndex = device!.containers
          .indexWhere((c) => c.containerId == event.containerId);
      // device!.containers.indexWhere((c) => c.id == event.containerId);
      if (containerIndex == -1) {
        emit(const DeviceError('Container not found'));
      }

      final updatedContainers = List<ContainerModel>.from(device!.containers);
      updatedContainers[containerIndex] =
          updatedContainers[containerIndex].copyWith(
        medicineName: event.medicineName,
        quantity: event.quantity,
      );

      device = device!.copyWith(containers: updatedContainers);
      emit(DeviceLoaded(device!));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onResetContainer(
      ResetContainer event, Emitter<DeviceState> emit) async {
    try {
      if (device == null) {
        emit(const DeviceError('Device not loaded'));
      }
      print(device?.toJson() ?? 'Device is null');

      final containerIndex = device!.containers
          .indexWhere((c) => c.containerId == event.containerId);
      // device!.containers.indexWhere((c) => c.id == event.containerId);
      if (containerIndex == -1) {
        emit(const DeviceError('Container not found'));
      }

      final updatedContainers = List<ContainerModel>.from(device!.containers);
      updatedContainers[containerIndex] =
          updatedContainers[containerIndex].copyWith(
        medicineName: null,
        quantity: 0,
      );

      device = device!.copyWith(containers: updatedContainers);
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
