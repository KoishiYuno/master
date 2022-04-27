import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/data_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  ChatCubit(
    this._dataRepository,
    this._authRepository,
  ) : super(ChatState.initial());

  void messageChanged(String message) {
    emit(state.copywith(
      message: message,
      status: ChatStatus.initial,
    ));
  }

  Future<void> submitNewMessage() async {
    if (state.status == ChatStatus.submitting) return;
    emit(state.copywith(status: ChatStatus.submitting));

    try {
      final response = await _dataRepository.getElderlyDetail(
          userid: _authRepository.currentUser.id);

      await _dataRepository.createNewMessage(
          message: state.message,
          id: _authRepository.currentUser.id,
          username: response.data()!['username']);

      emit(state.copywith(status: ChatStatus.success));
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: ChatStatus.error,
      ));
    }
  }
}
