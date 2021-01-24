import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var message = TextEditingController();
  String messagecheck = '';
  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": message.text.trim(),
      "CreatedAt": Timestamp.now(),
      "userID": user.uid,
      "username": userData['username'],
      "userimage": userData['userimage'],
    });
    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: message,
              decoration: InputDecoration(labelText: "Send a message "),
              onChanged: (value) {
                setState(() {
                  messagecheck = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: messagecheck.trim().isNotEmpty ? _sendMessage : null),
        ],
      ),
    );
  }
}
