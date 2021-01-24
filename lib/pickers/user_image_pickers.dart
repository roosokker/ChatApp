import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({this.imagePickFn});

  final void Function(File image) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File img;
  final picker = ImagePicker();
  void _pickImage() async {
    final resultImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      img = File(resultImage.path);
    });
    widget.imagePickFn(img);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
            radius: 30,
            backgroundImage: img != null ? FileImage(img) : null,
            backgroundColor: Colors.grey),
        Positioned(
          top: 40,
          bottom: 0,
          child: FlatButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera_alt, color: Theme.of(context).accentColor),
            label: Text(""),
          ),
        ),
      ],
    );
  }
}
