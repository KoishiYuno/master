import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/chat-cubit/chat_cubit.dart';

class NewMessage extends StatelessWidget {
  final _controller = TextEditingController();

  NewMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Send a new message',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                    onChanged: (message) {
                      context.read<ChatCubit>().messageChanged(message);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (state.message.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      context.read<ChatCubit>().submitNewMessage();
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
