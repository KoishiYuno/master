part of 'health_data_bloc.dart';

abstract class HealthDataEvent extends Equatable {
  const HealthDataEvent();

  @override
  List<Object> get props => [];
}

class LoadHealthData extends HealthDataEvent {}
