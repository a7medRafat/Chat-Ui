import 'package:flutter/cupertino.dart';

import 'MessagesScreen.dart';
import 'chat_ui_kit.dart';

class ChatScreen extends StatelessWidget {

   ChatScreen({super.key});
  final ChatModel chatModel = ChatModel(
      name: 'ahmed rafat',
      image:
      'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1720151681~exp=1720155281~hmac=2e8bcbe5e54837c0bb5e32b5f6eb7624c13f36f6e770eca178e1985263a06033&w=740',
      isRead: false,
      isMyMessage: false,
      id: 1,
      phoneNumber: '01206178117',
      lastMsg: 'test last');

  @override
  Widget build(BuildContext context) {
    return ChatUiKit(
      chatDate: DateTime.now(),
      endActionPaneName: 'a7med Rafat',
      endActionPaneNumber: '01098818702',
      context: context,
      screenNavigation: const MessageScreen(phoneNumber: '01206178117'),
      itemCount: 5,
      chatModel: chatModel,
    );
  }
}
