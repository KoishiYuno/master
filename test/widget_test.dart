// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:master/main.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/chat_repository.dart';
import 'package:master/repository/home_repository.dart';
import 'package:master/repository/fitbit_repository.dart';
import 'package:master/repository/link_code_repository.dart';
import 'package:master/repository/profile_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final AuthRepository authRepository = AuthRepository();
    final HomeRepository homeRepository = HomeRepository();
    final FitbitRepository fitbitRepository = FitbitRepository();
    final ChatRepository chatRepository = ChatRepository();
    final ProfileRepository profileRepository = ProfileRepository();
    final LinkCodeRepository linkCodeRepository = LinkCodeRepository();

    await tester.pumpWidget(MyApp(
      fitbitRepository: fitbitRepository,
      authRepository: authRepository,
      homeRepository: homeRepository,
      chatRepository: chatRepository,
      profileRepository: profileRepository,
      linkCodeRepository: linkCodeRepository,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
