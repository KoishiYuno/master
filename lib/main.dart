import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/config/theme.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/data_repository.dart';
import 'package:master/repository/fitbit_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final DataRepository dataRepository = DataRepository();
  final FitbitRepository fitbitRepository = FitbitRepository();

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
    dataRepository: dataRepository,
    fitbitRepository: fitbitRepository,
  ));
}

class MyApp extends StatefulWidget {
  final AuthRepository _authRepository;
  final DataRepository _dataRepository;
  final FitbitRepository _fitbitRepository;

  const MyApp({
    Key? key,
    required DataRepository dataRepository,
    required AuthRepository authRepository,
    required FitbitRepository fitbitRepository,
  })  : _dataRepository = dataRepository,
        _authRepository = authRepository,
        _fitbitRepository = fitbitRepository,
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
        value: widget._dataRepository,
        child: RepositoryProvider.value(
          value: widget._fitbitRepository,
          child: BlocProvider(
            create: (_) => AuthBloc(
                authRepository: widget._authRepository,
                dataRepository: widget._dataRepository),
            child: const AppView(),
          ),
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   final AuthRepository _authRepository;
//   final DataRepository _dataRepository;
//   final FitbitRepository _fitbitRepository;

//   const MyApp({
//     Key? key,
//     required DataRepository dataRepository,
//     required AuthRepository authRepository,
//     required FitbitRepository fitbitRepository,
//   })  : _dataRepository = dataRepository,
//         _authRepository = authRepository,
//         _fitbitRepository = fitbitRepository,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider.value(
//       value: _authRepository,
//       child: RepositoryProvider.value(
//         value: _dataRepository,
//         child: RepositoryProvider.value(
//           value: _fitbitRepository,
//           child: BlocProvider(
//             create: (_) => AuthBloc(authRepository: _authRepository),
//             child: const AppView(),
//           ),
//         ),
//       ),
//     );
//   }
// }

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder(
          state: context.select((AuthBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages),
    );
  }
}
