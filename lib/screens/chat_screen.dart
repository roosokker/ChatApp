import 'package:chatappcourse/widgets/chat/messages.dart';
import 'package:chatappcourse/widgets/chat/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FlutterChat",
        ),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              // ignore: missing_required_param
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Logout",
                        ),
                      ],
                    ),
                  ),
                  value: "Logout",
                ),
              ],
              onChanged: (itemIdentifier) async {
                if (itemIdentifier == "Logout") {
                  await FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.add,
      //   ),
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/OtRdLgvT1LorXUkhiG1W/messages')
      //         .add({'text': 'added by clicking the button'});
      //   },
      // ),
    );
  }
}
