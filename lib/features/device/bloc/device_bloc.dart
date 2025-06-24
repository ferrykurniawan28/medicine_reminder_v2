import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/device/domain/entities/device_control.dart';
import 'package:medicine_reminder/features/device/domain/usecases/get_device.dart';
import 'package:medicine_reminder/features/device/domain/usecases/get_device_control.dart';
import 'package:medicine_reminder/features/device/domain/usecases/get_device_control_count.dart';
import 'package:medicine_reminder/features/device/domain/usecases/reset_container.dart';
import 'package:medicine_reminder/features/device/domain/usecases/update_container.dart';
import 'package:medicine_reminder/features/device/domain/usecases/add_device.dart';
import 'package:medicine_reminder/features/device/domain/repositories/device_repository.dart';
import 'package:medicine_reminder/features/device/domain/entities/container.dart';
import 'package:meta/meta.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  Device? device;
  List<DeviceControl>? deviceControls;
  int? deviceControlsCount;

  final AddDevice addDevice;
  final GetDevice getDevice;
  final ContainerUpdate updateContainer;
  final ContainerReset resetContainer;
  final DeviceRepository deviceRepository;
  final GetDeviceControlCount getDeviceControlCount;
  final GetDeviceControl getDeviceControl;

  DeviceBloc(this.deviceRepository)
      : addDevice = AddDevice(deviceRepository),
        getDevice = GetDevice(deviceRepository),
        updateContainer = ContainerUpdate(deviceRepository),
        resetContainer = ContainerReset(deviceRepository),
        getDeviceControlCount = GetDeviceControlCount(deviceRepository),
        getDeviceControl = GetDeviceControl(deviceRepository),
        super(DeviceInitial()) {
    on<DeviceFetch>(_onFetchDevice);
    on<DeviceRefresh>(_onRefreshDevices);
    on<LoadDeviceDetail>(_onLoadDevice);
    on<DeviceUpdate>(_onDeviceUpdate);
    on<UpdateContainer>(_onUpdateContainer);
    on<ResetContainer>(_onResetContainer);
    on<DeviceAdd>(_onAddDevice);
    on<DeviceControlFetch>(_onFetchDeviceControl);
  }

  Future<void> _onFetchDevice(
      DeviceFetch event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      device = await getDevice(event.userId);
      if (device != null) {
        deviceControlsCount = await getDeviceControlCount(device!.id!);
        print('Device controls count: $deviceControlsCount');
        emit(DeviceLoaded(device!, deviceControlsCount: deviceControlsCount));
      } else {
        emit(const DeviceError('No device found'));
      }
    } catch (e) {
      print('Error fetching device: $e');
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onAddDevice(DeviceAdd event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      device = await addDevice(event.userId, event.deviceUid);
      if (device != null) {
        emit(DeviceLoaded(device!));
      } else {
        emit(const DeviceError('Failed to add device'));
      }
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
        device = null;
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
        return;
      }
      final containerIndex = device!.containers
          .indexWhere((c) => c.containerId == event.containerId);
      if (containerIndex == -1) {
        emit(const DeviceError('Container not found'));
        return;
      }
      final updatedContainers = List<DeviceContainer>.from(device!.containers);
      updatedContainers[containerIndex] =
          updatedContainers[containerIndex].copyWith(
        medicineName: event.medicineName,
        quantity: event.quantity,
      );
      device = device!.copyWith(containers: updatedContainers);
      // print('Updated device: ${device!.toJson()}');
      emit(DeviceLoaded(device!));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onResetContainer(
      ResetContainer event, Emitter<DeviceState> emit) async {
    try {
      await resetContainer(event.userId, event.containerId);
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onFetchDeviceControl(
      DeviceControlFetch event, Emitter<DeviceState> emit) async {
    try {
      if (device == null) {
        emit(const DeviceError('Device not loaded'));
        return;
      }

      deviceControls = await getDeviceControl(device!.id!);
      if (deviceControls != null) {
        emit(DeviceControlLoaded(deviceControls!));
      } else {
        emit(const DeviceError('No device controls found'));
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
