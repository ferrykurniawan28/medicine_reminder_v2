import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/device/domain/usecases/get_device.dart';
import 'package:medicine_reminder/features/device/domain/usecases/update_device.dart';
import 'package:medicine_reminder/features/device/domain/usecases/refresh_device.dart';
import 'package:medicine_reminder/features/device/data/repositories/device_repository_impl.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource_impl.dart';
import 'package:medicine_reminder/features/device/domain/entities/container.dart';
import 'package:meta/meta.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  Device? device;

  final GetDevice getDevice;
  final UpdateDevice updateDevice;
  final RefreshDevice refreshDevice;

  DeviceBloc()
      : getDevice =
            GetDevice(DeviceRepositoryImpl(DeviceLocalDataSourceImpl())),
        updateDevice =
            UpdateDevice(DeviceRepositoryImpl(DeviceLocalDataSourceImpl())),
        refreshDevice =
            RefreshDevice(DeviceRepositoryImpl(DeviceLocalDataSourceImpl())),
        super(DeviceInitial()) {
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
      // Simulate API fetch (replace with real API call when ready)
      final fetchedDevice = DeviceModel(
        id: event.deviceId,
        uuid: 'uuid-${event.deviceId}',
        currentState: 0,
        temperature: 25,
        humidity: 50,
        containers: List.generate(
            5,
            (i) => ContainerModel(
                  id: i + 1,
                  deviceId: event.deviceId,
                  containerId: i + 1,
                  medicineName: null,
                  quantity: 0,
                )),
      );
      // Check if local device exists and matches deviceId
      final localDevice = await getDevice.call(event.deviceId);
      bool needsUpdate = false;
      if (localDevice == null || localDevice.id != event.deviceId) {
        needsUpdate = true;
      } else {
        final DeviceModel local = localDevice as DeviceModel;
        // Compare fields
        if (local.currentState != fetchedDevice.currentState ||
            local.temperature != fetchedDevice.temperature ||
            local.humidity != fetchedDevice.humidity ||
            local.containers.length != fetchedDevice.containers.length) {
          needsUpdate = true;
        } else {
          for (int i = 0; i < local.containers.length; i++) {
            final lc = local.containers[i] as ContainerModel;
            final fc = fetchedDevice.containers[i] as ContainerModel;
            if (lc.containerId != fc.containerId ||
                lc.medicineName != fc.medicineName ||
                lc.quantity != fc.quantity) {
              needsUpdate = true;
              break;
            }
          }
        }
      }
      if (needsUpdate) {
        await updateDevice.call(fetchedDevice);
        device = fetchedDevice;
      } else {
        device = localDevice as DeviceModel;
      }
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
        medicineName: null,
        quantity: 0,
      );
      device = device!.copyWith(containers: updatedContainers) as DeviceModel;
      emit(DeviceLoaded(device!));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
