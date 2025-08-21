import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/parental/domain/repositories/parental_repository.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/features/parental/domain/entities/parental.dart';
import 'package:medicine_reminder/features/parental/domain/usecases/parental_usecases.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

part 'parental_event.dart';
part 'parental_state.dart';

class ParentalBloc extends Bloc<ParentalEvent, ParentalState> {
  final GetParentals getParentals;
  final AddParental addParental;
  final DeleteParental deleteParental;
  final GetParentalReminder getParentalReminder;
  final GetParentalAppointment getParentalAppointment;
  final GetParentalDevice getParentalDevice;
  final ParentalRepository repository;

  List<Parental> _parentals = [];
  List<Reminder>? _reminders = [];
  List<Appointment>? _appointments = [];
  Device? _deviceModel;

  ParentalBloc(this.repository)
      : getParentals = GetParentals(repository),
        addParental = AddParental(repository),
        deleteParental = DeleteParental(repository),
        getParentalReminder = GetParentalReminder(repository),
        getParentalAppointment = GetParentalAppointment(repository),
        getParentalDevice = GetParentalDevice(repository),
        super(ParentalInitial()) {
    on<LoadParentals>(_onFetchParentals);
    // on<LoadParental>(_onFetchParental);
    on<ParentalAdd>(_onAddParental);
    on<ParentalUpdate>(_onUpdateParental);
    on<ParentalDelete>(_onDeleteParental);
    on<LoadReminderParental>(_onFetchReminderParental);
    on<LoadAppointmentParental>(_onFetchAppointmentParental);
    on<LoadDeviceParental>(_onFetchDeviceParental);
  }

  Future<void> _onFetchParentals(
      LoadParentals event, Emitter<ParentalState> emit) async {
    emit(ParentalListLoading());
    try {
      _parentals = await getParentals(event.userId);
      emit(ParentalsLoaded(_parentals));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onAddParental(
      ParentalAdd event, Emitter<ParentalState> emit) async {
    try {
      await addParental(event.parental, event.userId);
      // Reload the parentals list
      if (state is ParentalsLoaded) {
        add(LoadParentals(event.parental.id!));
      }
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onUpdateParental(
      ParentalUpdate event, Emitter<ParentalState> emit) async {
    try {
      // await updateParental(event.parental);
      // Reload the parentals list
      if (state is ParentalsLoaded) {
        add(LoadParentals(event.parental.id!));
      }
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onDeleteParental(
      ParentalDelete event, Emitter<ParentalState> emit) async {
    try {
      await deleteParental(event.id);
      // Remove from local list
      _parentals.removeWhere((p) => p.id == event.id);
      emit(ParentalsLoaded(_parentals));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchReminderParental(
      LoadReminderParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _reminders = await getParentalReminder(event.parentalId);
      emit(ReminderParentalLoaded(_reminders));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchAppointmentParental(
      LoadAppointmentParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _appointments = await getParentalAppointment(event.parentalId);
      emit(AppointmentParentalLoaded(_appointments));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchDeviceParental(
      LoadDeviceParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _deviceModel = await getParentalDevice(event.parentalId);
      emit(DeviceParentalLoaded(_deviceModel));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }
}
