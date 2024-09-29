import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat/component/appbar.dart';
import 'package:flutter_chat/component/messages.dart';
import 'package:flutter_chat/model/user.dart';
import 'dart:developer' as developer;
import 'package:flutter_chat/websocket.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<User> users = [];
  TextEditingController textController = TextEditingController();
  late String username; // Store the sender's username

  @override
  void initState() {
    super.initState();

    // You might want to set this from the logged-in user info
    username =
        MyWebSocket.instance.username; // Replace this with actual username

    // Subscribe to receive messages from the /chatroom/message topic
    myWebSocket.client.subscribe(
      destination: '/chatroom/message',
      callback: (frame) {
        developer.log('Received: ${frame.body}');

        if (frame.body != null) {
          Map<String, dynamic> receivedMessage = jsonDecode(frame.body!);

          // Only add messages that are not sent by the current user
          if (receivedMessage['sender'] != username) {
            setState(() {
              users.add(
                User(
                  sender: receivedMessage['sender'],
                  message: receivedMessage['message'],
                ),
              );
            });
          }
        }
      },
    );
  }

  void onSendMessage(String message) {
    // Construct JSON message to match backend
    final jsonMessage = {"sender": username, "message": message};

    // Send message to backend
    myWebSocket.client.send(
      destination: '/app/chat',
      body: jsonEncode(jsonMessage),
    );

    // Add the message to the list immediately after sending
    setState(() {
      users.add(User(sender: username, message: message));
      developer.log("Sent message: $message");
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
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.teal[500],
                    child: IconButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          developer.log('Not Empty');
                          onSendMessage(textController.text);
                        } else {
                          developer.log('Empty');
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
