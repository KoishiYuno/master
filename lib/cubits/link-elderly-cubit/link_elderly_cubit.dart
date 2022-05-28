import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_repository.dart';
import '../../repository/home_repository.dart';

part 'link_elderly_state.dart';

class LinkElderlyCubit extends Cubit<LinkElderlyState> {
  final HomeRepository _homeRepository;
  final AuthRepository _authRepository;
  LinkElderlyCubit(
    this._homeRepository,
    this._authRepository,
  ) : super(LinkElderlyState.initial());

  void codeChanged(String code) {
    emit(state.copywith(
      code: code,
      status: LinkElderlyStatus.initial,
    ));
  }

  Future<void> linkElderly() async {
    if (state.status == LinkElderlyStatus.submitting) return;
    emit(state.copywith(status: LinkElderlyStatus.submitting));

    try {
      final String targetId = await _homeRepository.linkElderly(
        code: state.code,
        userId: _authRepository.currentUser.id,
      );

      emit(state.copywith(
        code: targetId,
        status: LinkElderlyStatus.success,
      ));
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: LinkElderlyStatus.error,
      ));
    }
  }
}
