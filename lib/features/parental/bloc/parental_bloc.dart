import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/models/models.dart';

part 'parental_event.dart';
part 'parental_state.dart';

class ParentalBloc extends Bloc<ParentalEvent, ParentalState> {
  List<Parental> _parentals = [];
  List<ReminderModel>? _reminders = [];
  List<Appointment>? _appointments = [];
  DeviceModel? _deviceModel;
  ParentalBloc() : super(ParentalInitial()) {
    on<LoadParentals>(_onFetchParentals);
    on<LoadParental>(_onFetchParental);
    // on<AddParental>(_onAddParental);
    // on<UpdateParental>(_onUpdateParental);
    // on<DeleteParental>(_onDeleteParental);
    on<LoadReminderParental>(_onFetchReminderParental);
    on<LoadAppointmentParental>(_onFetchAppointmentParental);
    on<LoadDeviceParental>(_onFetchDeviceParental);
  }

  Future<void> _onFetchParentals(
      LoadParentals event, Emitter<ParentalState> emit) async {
    emit(ParentalListLoading());
    try {
      _parentals = dummyParental;
      // final parentals = await _parentalRepository.getParental(event.userId);
      emit(ParentalsLoaded(_parentals));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchParental(
      LoadParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      final parental =
          _parentals.firstWhere((element) => element.id == event.userId);
      // _parental = dummyParental.firstWhere((element) => element.id == event.id);
      // final parental = await _parentalRepository.getParental(event.id);
      emit(ParentalLoaded(parental));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchReminderParental(
      LoadReminderParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _reminders = dummyReminders;
      // final reminders = await _reminderRepository.getReminder(event.parentalId);
      emit(ReminderParentalLoaded(_reminders!));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchAppointmentParental(
      LoadAppointmentParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _appointments = dummyAppointment;
      // final appointments =
      //     await _appointmentRepository.getAppointment(event.parentalId);
      emit(AppointmentParentalLoaded(_appointments!));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }

  Future<void> _onFetchDeviceParental(
      LoadDeviceParental event, Emitter<ParentalState> emit) async {
    emit(ParentalLoading());
    try {
      _deviceModel = dummyDevice;
      // final deviceModel =
      //     await _deviceRepository.getDevice(event.parentalId);
      emit(DeviceParentalLoaded(_deviceModel!));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }
}
