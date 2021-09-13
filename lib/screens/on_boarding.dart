import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssnbt/services/authentication_service.dart';

import 'home.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _authInstance = AuthenticationService();
  bool _isHosteller = false;
  Future setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isHosteller", _isHosteller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${_authInstance.getUserName() ?? 'User'}',
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
              Image.asset(
                'assets/onBoardingLogo.png',
                width: double.infinity,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text("Are you a ?",
                    style: TextStyle(color: Colors.white, fontSize: 28)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: (_isHosteller) ? Colors.white : Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 60, horizontal: 10),
                        ),
                        onPressed: () async {
                          _isHosteller = false;
                          await setPrefs();
                          setState(() {});
                        },
                        child: Column(children: [
                          Icon(Icons.directions_bus,
                              color:
                                  (_isHosteller) ? Colors.blue : Colors.white),
                          const SizedBox(height: 5),
                          Text(
                            'Day-Scholar',
                            style: TextStyle(
                                fontSize: 24,
                                color: (_isHosteller)
                                    ? Colors.blue
                                    : Colors.white),
                          )
                        ]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  (_isHosteller) ? Colors.blue : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 60, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              _isHosteller = true;
                              await setPrefs();
                              setState(() {});
                            },
                            child: Column(children: [
                              Icon(
                                Icons.apartment,
                                color:
                                    (_isHosteller) ? Colors.white : Colors.blue,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Hosteller',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: (_isHosteller)
                                        ? Colors.white
                                        : Colors.blue),
                              )
                            ])))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setBool('firstTime', false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15)),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Color(0xFF5274EF)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
