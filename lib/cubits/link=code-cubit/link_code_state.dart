part of 'link_code_cubit.dart';

enum LinkCodeStatus { initial, success, error }

class LinkCodeState extends Equatable {
  final String code;
  final String error;
  final LinkCodeStatus status;

  const LinkCodeState({
    required this.code,
    required this.error,
    required this.status,
  });

  factory LinkCodeState.initial() {
    return const LinkCodeState(
      code: '',
      error: '',
      status: LinkCodeStatus.initial,
    );
  }

  @override
  List<Object> get props => [code, status, error];

  LinkCodeState copywith({
    String? code,
    String? error,
    String? docID,
    String? username,
    LinkCodeStatus? status,
  }) {
    return LinkCodeState(
      code: code ?? this.code,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
