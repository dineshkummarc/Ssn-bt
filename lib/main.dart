import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssnbt/services/AuthenticationService.dart';
import 'package:ssnbt/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ssn Bus Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamProvider<User?>.value(
          catchError: (_, __) => null,
          initialData: null,
          value: AuthenticationService().onAuthStateChanged,
          builder: (context, snapshot) {
            return Wrapper();
          }),
    );
  }
}
