import 'package:chatui/message_ui_kit.dart';
import 'package:flutter/material.dart';
class MessageScreen extends StatelessWidget {

  final String phoneNumber;

  const MessageScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return MessageUiKit(
      phoneNumber: 'aaaa',
      sendMessageBtnColor: Colors.green,
      dayDateColor: Colors.orange.withOpacity(0.3),
      dayDateTextColor: Colors.white,
      messageTextColor: Colors.blue,
      receiverColor: Colors.purple.withOpacity(0.2),
      messageDateColor: Colors.red,
      scaffoldColor: Colors.green.withOpacity(0.1),
      textFieldColor: Colors.deepOrange.withOpacity(0.1),
      isFilled: true,
    );
  }
}
