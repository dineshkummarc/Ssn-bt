import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssnbt/services/AuthenticationService.dart';

import 'screens/OnBoarding.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _authInstance = AuthenticationService();
  bool firstTime = true;
  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool("firstTime") ?? true;
  }

  Future signInWithGoogle() async {
    dynamic result = await _authInstance.signInWithGoogle();
    if (result == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
                title: Text("Invalid Login"),
                content: Text("Please Log in with ssn mail id"),
                actions: [
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        signInWithGoogle();
                      }),
                ],
              ));
    }
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      signInWithGoogle();
      return Scaffold(
        backgroundColor: Color(0xFF5274EF),
      );
    } else {
      if (firstTime) {
        return OnBoarding();
      } else {}
      return OnBoarding();
    }
  }
}
