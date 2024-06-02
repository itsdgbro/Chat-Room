import 'package:flutter/material.dart';
import 'package:flutter_chat/websocket.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

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
          // Title Container
          SizedBox(
            width: double.infinity,
            child: Text(
              'Flutter + Spring WebSocket',
              style: TextStyle(color: Colors.teal[500], fontSize: 40),
              textAlign: TextAlign.center,
            ),
          ),
          // Center container
          Expanded(
            // Wrap with Expanded widget
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextField(
                      controller: controller,
                      cursorColor: Colors.teal[500],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        border: UnderlineInputBorder(),
                        hintText: 'Your username',
                      ),
                    ),
                  ),
                  // gap in between
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[500],
                    ),
                    onPressed: (() => {
                          if (controller.text.isNotEmpty)
                            {
                              MyWebSocket.instance.setShowError(true),
                              MyWebSocket.instance.setContext(context),
                              MyWebSocket.instance.connectStompSocket(),
                            }
                          else
                            {
                              Fluttertoast.showToast(
                                  msg: 'Invalid username',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white)
                            }
                        }),
                    icon: const Icon(
                      Icons.connect_without_contact,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Connect',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
