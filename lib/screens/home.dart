import 'package:flutter/material.dart';
import 'package:ssnbt/services/AuthenticationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authInstance = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5274EF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Welcome ${_authInstance.getUserName() ?? 'User'}',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            Image.asset('assets/onBoardingLogo.png'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text("Are you a ?",
                  style: TextStyle(color: Colors.white, fontSize: 28)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                      ),
                      onPressed: () {},
                      child: Column(children: [
                        Image.asset(
                          'assets/dayScholar.png',
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Day-Scholar',
                          style:
                              TextStyle(fontSize: 24, color: Color(0xFF5274EF)),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 60, horizontal: 10),
                          ),
                          onPressed: () {},
                          child: Column(children: [
                            Image.asset('assets/hosteller.png'),
                            SizedBox(height: 5),
                            Text(
                              'Hosteller',
                              style: TextStyle(
                                  fontSize: 24, color: Color(0xFF5274EF)),
                            )
                          ])))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
              child: ElevatedButton(
                onPressed: () {
                  _authInstance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text(
                  "Sign out",
                  style: TextStyle(color: Color(0xFF5274EF)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
