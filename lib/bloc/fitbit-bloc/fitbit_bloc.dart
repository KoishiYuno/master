import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fitbit_event.dart';
part 'fitbit_state.dart';

class FitbitBloc extends Bloc<FitbitEvent, FitbitState> {
  FitbitBloc() : super(FitbitInitial()) {
    on<FitbitEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
