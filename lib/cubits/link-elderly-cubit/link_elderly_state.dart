part of 'link_elderly_cubit.dart';

enum LinkElderlyStatus { initial, submitting, success, error }

class LinkElderlyState extends Equatable {
  final String code;
  final LinkElderlyStatus status;
  final String error;

  const LinkElderlyState({
    required this.code,
    required this.error,
    required this.status,
  });

  factory LinkElderlyState.initial() {
    return const LinkElderlyState(
      code: '',
      error: '',
      status: LinkElderlyStatus.initial,
    );
  }

  @override
  List<Object> get props => [code, status, error];

  LinkElderlyState copywith({
    String? code,
    String? error,
    String? docID,
    String? username,
    LinkElderlyStatus? status,
  }) {
    return LinkElderlyState(
      code: code ?? this.code,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
