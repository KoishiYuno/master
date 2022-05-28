import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/home_repository.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:crypto/crypto.dart';
import 'package:master/repository/fitbit_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final AuthRepository _authRepository;
  final FitbitRepository _fitbitRepository;

  HomeBloc({
    required HomeRepository dataRepository,
    required AuthRepository authRepository,
    required FitbitRepository fitbitRepository,
  })  : _homeRepository = dataRepository,
        _authRepository = authRepository,
        _fitbitRepository = fitbitRepository,
        super(HomeInitial()) {
    on<CheckFitbitAccessToken>(_onCheckFitbitAccessToken);
    on<SigninToFitbit>(_onSigninToFitbit);
    on<UpdateHealthData>(_onUpdateHealthData);
  }

  Future<void> _onCheckFitbitAccessToken(
    CheckFitbitAccessToken event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final data = await _homeRepository.getElderlyDetail(
          userid: _authRepository.currentUser.id);

      if (data.data()!['userType'] == 'Elderly') {
        if (data.data()!.containsKey('access_token')) {
          emit(FitbitAcessTokenExisted());
        } else {
          emit(FitbitAcessTokenMissed());
        }
      }

      if (data.data()!['userType'] == 'Caregivers' ||
          data.data()!['userType'] == 'Dependant') {
        if (data.data()!.containsKey('elderly')) {
          emit(ElderlyAccountLinked());
        } else {
          emit(ElderlyAccountMissed());
        }
      }
    } catch (e) {
      emit(FitbitAuthorizationFailed(error: e.toString()));
    }
  }

  Future<void> _onUpdateHealthData(
    UpdateHealthData event,
    Emitter<HomeState> emit,
  ) async {
    String access_token = '';
    final userDetail = await _homeRepository.getElderlyDetail(
        userid: _authRepository.currentUser.id);

    final current = DateTime.now();
    final end = current;
    final start = current.subtract(const Duration(minutes: 15));

    var formatterTime = DateFormat('kk:mm');
    var formatterDate = DateFormat('dd-MM-yyyy');

    print(userDetail.data()!['expires_in']);
    print(DateTime.now().millisecondsSinceEpoch);
    print(userDetail.data());

    if (userDetail.data()!['expires_in'] <
        DateTime.now().millisecondsSinceEpoch) {
      try {
        final credentialMap =
            await _fitbitRepository.getAccessTokenByRefreshToken(
                refreshToken: userDetail.data()!['refresh_token']);

        await _homeRepository.updateFitbitAccessToken(
          id: _authRepository.currentUser.id,
          accessToken: credentialMap['access_token'],
          refreshToken: credentialMap['refresh_token'],
          expiresIn: credentialMap['expires_in'],
        );

        access_token = credentialMap['access_token'];
      } catch (e) {
        rethrow;
      }
    } else {
      access_token = userDetail.data()!['access_token'];
    }

    final data = await _fitbitRepository.getCurrentHeartRate(
      userId: userDetail.data()!['user_id'],
      date: "today",
      start: formatterTime.format(start),
      end: formatterTime.format(end),
      accessToken: access_token,
    );

    List lastHeartRate;

    if (data['activities-heart-intraday']['dataset'].length > 0) {
      lastHeartRate =
          data['activities-heart-intraday']['dataset'].last.values.toList();
    } else {
      lastHeartRate = [formatterTime.format(current), 0];
    }

    await _homeRepository.createNewHeartRateRecord(
      data: lastHeartRate,
      date: formatterDate.format(current),
      id: _authRepository.currentUser.id,
    );

    emit(HealthDataUpdated());

    // print(data);

    // print(userDetail.data()!['access_token']);
  }

  void _onSigninToFitbit(SigninToFitbit event, Emitter<HomeState> emit) async {
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    String authorizationCode = '';

    String codeVerifier = generateCodeVerifier();
    String codeChallenge = base64Url
        .encode(sha256.convert(ascii.encode(codeVerifier)).bytes)
        .replaceAll("=", "")
        .replaceAll("+", "-")
        .replaceAll("/", "_");

    final String selectedUrl =
        'https://www.fitbit.com/oauth2/authorize?client_id=23843J&response_type=code&code_challenge=$codeChallenge&code_challenge_method=S256&scope=weight%20location%20settings%20profile%20nutrition%20activity%20sleep%20heartrate%20social';

    flutterWebViewPlugin.launch(
      selectedUrl,
      supportMultipleWindows: true,
      userAgent: 'random',
      clearCookies: true,
      rect: Rect.fromLTWH(
        0,
        0.0,
        MediaQuery.of(event.context).size.width,
        MediaQuery.of(event.context).size.height - 50,
      ),
    );

    await flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.contains('https://emsoftfitbit.com')) {
        authorizationCode = getAuthorizationCodeByURL(url: url);

        flutterWebViewPlugin.dispose();
      }
    }).asFuture();

    print(authorizationCode);

    final fitbitCredentials =
        await _fitbitRepository.getTokensByAuthorizationcode(
      code: authorizationCode,
      codeVerifier: codeVerifier,
    );

    try {
      if (fitbitCredentials.containsKey('access_token')) {
        await _homeRepository.storeFitbitCredentials(
            id: _authRepository.currentUser.id,
            fitbitCredentials: fitbitCredentials);
        flutterWebViewPlugin.close();
        emit(FitbitAcessTokenExisted());
      } else {
        emit(FitbitAcessTokenMissed());
      }
    } catch (e) {
      rethrow;
    }
  }

  String generateCodeVerifier() {
    const String _charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

    return List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  String getAuthorizationCodeByURL({
    required String url,
  }) {
    const start = "https://emsoftfitbit.com/?code=";
    const end = "#_=_";

    final startIndex = url.indexOf(start);
    final endIndex = url.indexOf(end, startIndex + start.length);

    return url.substring(startIndex + start.length, endIndex);
  }
}
