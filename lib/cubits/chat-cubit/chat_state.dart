part of 'chat_cubit.dart';

enum ChatStatus { initial, submitting, success, error }

class ChatState extends Equatable {
  final String message;
  final ChatStatus status;
  final String error;

  const ChatState({
    required this.message,
    required this.error,
    required this.status,
  });

  factory ChatState.initial() {
    return const ChatState(
      message: '',
      error: '',
      status: ChatStatus.initial,
    );
  }

  @override
  List<Object> get props => [message, status, error];

  ChatState copywith({
    String? message,
    String? error,
    ChatStatus? status,
  }) {
    return ChatState(
      message: message ?? this.message,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
