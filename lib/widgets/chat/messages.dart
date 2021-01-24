import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy("CreatedAt", descending: true)
            .snapshots(),
        builder: (ctx, chatsnapshot) {
          if (chatsnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final doc = chatsnapshot.data.docs;
          return ListView.builder(
            reverse: true,
            itemCount: doc.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(8.0),
              child: MessageBubble(
                message: doc[index]['text'],
                isMe: doc[index]['userID'] == currentUser.uid,
                username: doc[index]['username'],
                userImage: doc[index]['userimage'],
              ),
            ),
          );
        });
  }
}
