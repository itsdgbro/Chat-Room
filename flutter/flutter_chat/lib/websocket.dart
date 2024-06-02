import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:developer' as developer;

class MyWebSocket {
  // Singleton instance
  static MyWebSocket? _instance;

  // Private constructor
  MyWebSocket._();

  // Singleton instance getter
  static MyWebSocket get instance {
    // Lazily initialize the instance if it's null
    _instance ??= MyWebSocket._();
    return _instance!;
  }

  late StompClient client;
  bool showError = false;
  late BuildContext context;

  void setShowError(bool value) {
    showError = value;
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  void onConnectCallback(StompFrame connectFrame) {
    developer.log('Connected');
    if (Navigator.canPop(context)) {
      return;
    }
    Navigator.pushNamed(context, '/chatroom');
  }

  void connectStompSocket() {
// Completer to wait for connection completion
    Completer<void> completer = Completer<void>();

    client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8081/ws',
        onConnect: (StompFrame connectFrame) {
          onConnectCallback(connectFrame);
          completer.complete(); // Mark the connection as completed
        },
      ),
    );

    client.activate();

    // Wait for the connection to complete or timeout
    completer.future.then((_) {
      // Connection successful
      developer.log("DG Connection Successful");
    }).catchError((error) {
      // Connection attempt failed, server is likely offline
      developer.log("Server is offline");
      if (showError) {
        Fluttertoast.showToast(
          msg: 'Failed to connect with Server (Timeout)',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      showError = false;
    });
  }
}

// Create an instance of MyWebSocket
MyWebSocket myWebSocket = MyWebSocket.instance;
