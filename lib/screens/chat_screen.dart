import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/widgets/bottom_nav_bar.dart';

import '../cubits/chat-cubit/chat_cubit.dart';
import '../repository/auth_repository.dart';
import '../repository/data_repository.dart';
import '../widgets/chat-widgets/view.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ChatScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: BlocProvider<ChatCubit>(
        create: (_) => ChatCubit(
          context.read<DataRepository>(),
          context.read<AuthRepository>(),
        ),
        child: BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.status == ChatStatus.error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: _ChatView(),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Message(),
        ),
        NewMessage(),
      ],
    );
  }
}
