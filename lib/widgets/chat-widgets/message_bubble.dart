import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final bool isMe;
  final String message;
  final String date;
  final String username;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.date,
    required this.isMe,
    required this.username,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    print(widget.isMe);
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: widget.isMe
                    ? const EdgeInsets.only(right: 8.0)
                    : const EdgeInsets.only(left: 8.0),
                child: Text('${widget.username} at ${widget.date}'),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                  color: widget.isMe
                      ? const Color.fromRGBO(150, 158, 225, 1.0)
                      : Colors.grey.shade400,
                  borderRadius: widget.isMe
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                ),
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              // Container(
              //   padding: widget.isMe
              //       ? const EdgeInsets.only(right: 8.0)
              //       : const EdgeInsets.only(left: 8.0),
              //   child: Text(),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
