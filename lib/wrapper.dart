import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssnbt/services/AuthenticationService.dart';
import 'screens/OnBoarding.dart';
import 'screens/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _authInstance = AuthenticationService();
  Future<bool> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool("firstTime") ?? true;
    return firstTime;
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
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      signInWithGoogle();
      return Scaffold();
    } else {
      return FutureBuilder<bool>(
          future: getPrefs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return OnBoarding();
              } else {
                return Home();
              }
            }
            return CircularProgressIndicator(
              color: Colors.white,
            );
          });
    }
  }
}
