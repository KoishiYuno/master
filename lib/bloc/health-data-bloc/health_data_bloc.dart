import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';

import '../../repository/data_repository.dart';

part 'health_data_event.dart';
part 'health_data_state.dart';

class HealthDataBloc extends Bloc<HealthDataEvent, HealthDataState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  StreamSubscription? _healthDataSubscription;

  HealthDataBloc({
    required DataRepository dataRepository,
    required AuthRepository authRepository,
  })  : _dataRepository = dataRepository,
        _authRepository = authRepository,
        super(HealthDataInitial()) {
    on<LoadHealthData>(_onLoadHealthData);
  }

  Future<void> _onLoadHealthData(
    LoadHealthData event,
    Emitter<HealthDataState> emit,
  ) async {
    print(111111222);
    _healthDataSubscription?.cancel();
    _healthDataSubscription = _dataRepository
        .getHeartRate(
            userid: _authRepository.currentUser.id, date: '21-04-2022')
        .listen((healthData) {
      emit(HealthDataLoaded(healthData: healthData.data()!));
    });
  }

  @override
  Future<void> close() async {
    _healthDataSubscription?.cancel();
    return super.close();
  }
}
