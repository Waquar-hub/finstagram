import 'dart:io';

import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../constants.dart';
import 'package:file_picker/file_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseService? _firebaseService;
  GlobalKey<FormState> _registerformkey = GlobalKey<FormState>();
  String? _name, _email, _password;
  File? _image;
  double? _deviceHeight;
  double? _deviceWidth;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceHeight! * 0.05),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  titletext(),
                  _profileImageWidget(),
                  _registerField(),
                  _registerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titletext() {
    return Text(
      "Finstagram",
      style: kTextStyle,
    );
  }

  Widget _registerField() {
    return Container(
      height: _deviceHeight! * 0.30,
      child: Form(
        key: _registerformkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _nameField(),
            _emailField(),
            _passwordField(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageWidget() {
    var _imageprovider = _image != null
        ? FileImage(_image!)
        : const NetworkImage("https://i.pravatar.cc/400?img=2");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          setState(() {
            _image = File(_result!.files.first.path!);
          });
        });
      },
      child: Container(
          height: _deviceHeight! * 0.15,
          width: _deviceHeight! * 0.15,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _imageprovider as ImageProvider,
            ),
          )),
    );
  }

  Widget _nameField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(hintText: "Name"),
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        },
        validator: (_value) {
          return _value!.length > 0 ? null : "please enter the name";
        },
      ),
    );
  }

  Widget _emailField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Email..",
        ),
        onSaved: (_value) {
          setState(() {
            _email = _value;
          });
        },
        validator: (_value) {
          bool _result = _value!.contains(
            RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
          );
          return _result ? null : "enter valid email ";
        },
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "password..",
        ),
        onSaved: (_value) {
          setState(() {
            _password = _value;
          });
        },
        validator: (_value) {
          return _value!.length > 6
              ? null
              : "password should be grater then 6  ";
        },
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: _registorValidation,
      minWidth: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      color: Colors.red,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void _registorValidation() async {
    if (_registerformkey.currentState!.validate() && _image != null) {
      _registerformkey.currentState!.save();
      bool _result = await _firebaseService!.registerUser(
          name: _name!, email: _email!, password: _password!, image: _image!);
      if (_result) {
        Navigator.pop(context);
      }
    }
  }
}
