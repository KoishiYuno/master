part of 'health_data_bloc.dart';

abstract class HealthDataState extends Equatable {
  const HealthDataState();

  @override
  List<Object> get props => [];
}

class HealthDataInitial extends HealthDataState {}

class HealthDataLoaded extends HealthDataState {
  final Map<String, dynamic> healthData;

  const HealthDataLoaded({required this.healthData});

  @override
  List<Object> get props => [healthData];
}

class HealthDataError extends HealthDataState {
  final String error;

  const HealthDataError({required this.error});

  @override
  List<Object> get props => [error];
}
