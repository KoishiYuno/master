import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;

  ChatCubit(
    this._chatRepository,
    this._authRepository,
  ) : super(ChatState.initial());

  void messageChanged(String message) {
    emit(state.copywith(
      message: message,
      status: ChatStatus.initial,
    ));
  }

  Future<void> checkdocID() async {
    final response = await _chatRepository.getElderlyDetail(
        userid: _authRepository.currentUser.id);

    String docID = response.data()!.containsKey('elderly')
        ? response.data()!['elderly']
        : _authRepository.currentUser.id;

    emit(state.copywith(
      docID: docID,
      username: response.data()!['username'],
      status: ChatStatus.initial,
    ));
  }

  Future<void> submitNewMessage() async {
    if (state.status == ChatStatus.submitting) return;
    emit(state.copywith(status: ChatStatus.submitting));

    try {
      if (state.docID == '') {
        await checkdocID();
      }

      print(state);

      await _chatRepository.createNewMessage(
          message: state.message,
          id: _authRepository.currentUser.id,
          username: state.username,
          docID: state.docID);

      emit(state.copywith(status: ChatStatus.success));
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: ChatStatus.error,
      ));
    }
  }
}
