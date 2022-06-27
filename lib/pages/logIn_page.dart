import 'package:finstagram/constants.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  late double _deviceHeight;
  late double _deviceWidth;
  FirebaseService? _firebaseService;

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
          padding: EdgeInsets.symmetric(horizontal: _deviceHeight * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titletext(),
                _logInForm(),
                _loginButton(),
                registerPageLink()
              ],
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

  Widget _logInForm() {
    return Container(
      height: _deviceHeight * 0.20,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
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
        return _result ? null : "Please Enter the valid email";
      },
      decoration: InputDecoration(
        hintText: "Email..",
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      //An optional method to call with the final value when the form is saved via FormState.save.
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) {
        return _value!.length > 6 ? null : "Enter password grater than 6";
      },
      decoration: InputDecoration(
        hintText: "Password",
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        _logInUser();
      },
      child: Container(
        height: _deviceHeight * 0.07,
        width: _deviceWidth * 0.7,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Login",
              style: kButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget registerPageLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "register");
      },
      child: Text(
        "Don't have an account?",
        style: kNavigatorText,
      ),
    );
  }

  void _logInUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);
      if (_result) Navigator.popAndPushNamed(context, 'home');
    }
  }
}
