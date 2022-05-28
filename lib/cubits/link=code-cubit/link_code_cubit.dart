import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_repository.dart';
import '../../repository/link_code_repository.dart';

part 'link_code_state.dart';

class LinkCodeCubit extends Cubit<LinkCodeState> {
  final LinkCodeRepository _linkCodeRepository;
  final AuthRepository _authRepository;

  LinkCodeCubit(
    this._linkCodeRepository,
    this._authRepository,
  ) : super(LinkCodeState.initial());

  Future<void> generateLinkCode() async {
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;

    await _linkCodeRepository.updateLinkCode(
      code: code.toString(),
      id: _authRepository.currentUser.id,
    );

    emit(state.copywith(
      code: code.toString(),
      status: LinkCodeStatus.success,
    ));
  }
}
