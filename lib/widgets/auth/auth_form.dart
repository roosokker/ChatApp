import 'dart:io';

import 'package:chatappcourse/pickers/user_image_pickers.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({
    this.submitAuth,
    this.isLoading,
  });
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String pw,
    bool isLogin,
    BuildContext context,
    File img,
  ) submitAuth;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = TextEditingController();
  var _userName = TextEditingController();
  var _pw = TextEditingController();
  File _pickedImage;
  void _pickImage(File img) {
    setState(() {
      _pickedImage = img;
    });
  }

  void _trySubmit(BuildContext ctx) {
    final isValid = _formkey.currentState.validate();
    print(isValid);
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Pick image first"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      widget.submitAuth(
        _userEmail.text.trim(),
        _userName.text.trim(),
        _pw.text.trim(),
        _isLogin,
        ctx,
        _pickedImage,
      );
      _formkey.currentState.save();
      print(_userEmail);
      print(_userName);
      print(_pw);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      imagePickFn: _pickImage,
                    ),
                  if (!_isLogin)
                    TextFormField(
                      controller: _userName,
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "please enter at least 4 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  TextFormField(
                    controller: _userEmail,
                    key: ValueKey("email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return "please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email address",
                    ),
                  ),
                  TextFormField(
                    controller: _pw,
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "passwod ust be at least 6 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: () {
                        _trySubmit(context);
                      },
                      child: Text(_isLogin ? "Login" : "Create Account"),
                    ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _userEmail.clear();
                        _userName.clear();
                        _pw.clear();
                      });
                    },
                    child: Text(_isLogin
                        ? "Create new account"
                        : "Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
