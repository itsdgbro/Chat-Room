import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/component/appbar.dart';
import 'package:flutter_chat/component/messages.dart';
import 'package:flutter_chat/model/user.dart';
import 'dart:developer' as developer;

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<User> users = [];

  TextEditingController textController = TextEditingController();
  String message = "";

  void onSendMessage(String message) {
    setState(() {
      users.add(User(sender: 'Adam', message: message));
      developer.log(message);
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Chat Room'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return messageBox(sender: user.sender, message: user.message);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      cursorColor: Colors.teal[500],
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        contentPadding: const EdgeInsets.all(8.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.teal[500]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.teal[500]!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.teal[500],
                    child: IconButton(
                      onPressed: () => {
                        if (textController.text.isNotEmpty)
                          {
                            developer.log('Not Empty'),
                            onSendMessage(textController.text),
                          }
                        else
                          {
                            developer.log('Emptyy'),
                          }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
