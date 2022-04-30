part of 'chat_cubit.dart';

enum ChatStatus { initial, submitting, success, error }

class ChatState extends Equatable {
  final String username;
  final String docID;
  final String message;
  final ChatStatus status;
  final String error;

  const ChatState({
    required this.message,
    required this.error,
    required this.status,
    required this.docID,
    required this.username,
  });

  factory ChatState.initial() {
    return const ChatState(
      username: '',
      message: '',
      error: '',
      docID: '',
      status: ChatStatus.initial,
    );
  }

  @override
  List<Object> get props => [message, status, error, docID, username];

  ChatState copywith({
    String? message,
    String? error,
    String? docID,
    String? username,
    ChatStatus? status,
  }) {
    return ChatState(
      message: message ?? this.message,
      error: error ?? this.error,
      status: status ?? this.status,
      docID: docID ?? this.docID,
      username: username ?? this.username,
    );
  }
}
