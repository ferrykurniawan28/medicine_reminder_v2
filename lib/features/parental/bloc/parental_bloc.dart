import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/models/models.dart';

part 'parental_event.dart';
part 'parental_state.dart';

class ParentalBloc extends Bloc<ParentalEvent, ParentalState> {
  Parental? _parental;
  List<Parental> _parentals = [];
  ParentalBloc() : super(ParentalInitial()) {
    on<LoadParentals>(_onFetchParentals);
    on<LoadParental>(_onFetchParental);
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
      _parental = dummyParental.firstWhere((element) => element.id == event.id);
      // final parental = await _parentalRepository.getParental(event.id);
      emit(ParentalLoaded(_parental!));
    } catch (e) {
      emit(ParentalError(e.toString()));
    }
  }
}
