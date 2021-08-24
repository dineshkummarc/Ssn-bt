import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssnbt/screens/home.dart';
import 'package:ssnbt/services/AuthenticationService.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _authInstance = AuthenticationService();
  Future signInWithGoogle() async {
    dynamic result = await _authInstance.signInWithGoogle();
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please log in with ssn mail id")));
      signInWithGoogle();
    }
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
      return Home();
    }
  }
}
