import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/config/theme.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/chat_repository.dart';
import 'package:master/repository/home_repository.dart';
import 'package:master/repository/fitbit_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:master/repository/link_code_repository.dart';
import 'package:master/repository/profile_repository.dart';

import 'config/routes.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthRepository authRepository = AuthRepository();
  final HomeRepository homeRepository = HomeRepository();
  final FitbitRepository fitbitRepository = FitbitRepository();
  final ChatRepository chatRepository = ChatRepository();
  final ProfileRepository profileRepository = ProfileRepository();
  final LinkCodeRepository linkCodeRepository = LinkCodeRepository();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp(
    authRepository: authRepository,
    homeRepository: homeRepository,
    fitbitRepository: fitbitRepository,
    chatRepository: chatRepository,
    profileRepository: profileRepository,
    linkCodeRepository: linkCodeRepository,
  ));
}

class MyApp extends StatefulWidget {
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;
  final FitbitRepository _fitbitRepository;
  final ChatRepository _chatRepository;
  final ProfileRepository _profileRepository;
  final LinkCodeRepository _linkCodeRepository;

  const MyApp({
    Key? key,
    required HomeRepository homeRepository,
    required AuthRepository authRepository,
    required FitbitRepository fitbitRepository,
    required ChatRepository chatRepository,
    required ProfileRepository profileRepository,
    required LinkCodeRepository linkCodeRepository,
  })  : _homeRepository = homeRepository,
        _authRepository = authRepository,
        _fitbitRepository = fitbitRepository,
        _chatRepository = chatRepository,
        _profileRepository = profileRepository,
        _linkCodeRepository = linkCodeRepository,
        super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._authRepository,
      child: RepositoryProvider.value(
        value: widget._homeRepository,
        child: RepositoryProvider.value(
          value: widget._fitbitRepository,
          child: RepositoryProvider.value(
            value: widget._chatRepository,
            child: RepositoryProvider.value(
              value: widget._profileRepository,
              child: RepositoryProvider.value(
                value: widget._linkCodeRepository,
                child: BlocProvider(
                  create: (_) => AuthBloc(
                      authRepository: widget._authRepository,
                      homeRepository: widget._homeRepository,
                      targetID: ''),
                  child: const AppView(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated && state.targetID == '') {
          context.read<AuthBloc>().add(TargetIdUpdated());
        }
        return MaterialApp(
          theme: theme,
          home: FlowBuilder(
              state: context.select((AuthBloc bloc) => bloc.state.status),
              onGeneratePages: onGenerateAppViewPages),
        );
      },
    );
  }
}
