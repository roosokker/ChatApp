import 'dart:io';

import 'package:chatappcourse/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuth(
    String email,
    String username,
    String pw,
    bool isLogin,
    BuildContext context,
    File img,
  ) async {
    try {
      setState(() {
        _isLoading = true;
        print("authscreen isloading = $_isLoading");
        print("authscreen email = $email");
        print("authscreen username = $username");
        print("authscreen pw = $pw");
        print("authscreen islogin = $isLogin");
      });
      var authResult;
      if (isLogin) {
        authResult =
            await _auth.signInWithEmailAndPassword(email: email, password: pw);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pw);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + ".jpg");
        await ref.putFile(img);
        final imageURL = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          "username": username,
          "email": email,
          "userimage": imageURL,
        });
      }
    } on PlatformException catch (e) {
      var error = "Please check your credentials";
      if (e.message != null) {
        error = e.message;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitAuth: _submitAuth,
        isLoading: _isLoading,
      ),
    );
  }
}
