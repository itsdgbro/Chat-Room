import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Chat',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.teal[500],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Chat Room',
              style: TextStyle(
                  color: Colors.teal[500],
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(child: ChatBox()),
        ],
      ),
    );
  }
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<StatefulWidget> createState() => _ChatBox();
}

class _ChatBox extends State<ChatBox> {
  final List<types.Message> _messages = [];
  final _user = types.User(
    id: UniqueKey().toString(),
  );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      scrollPhysics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: _user,
    );
  }
}
