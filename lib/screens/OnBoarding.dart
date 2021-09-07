import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssnbt/services/AuthenticationService.dart';
import 'home.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _authInstance = AuthenticationService();
  bool isHosteller = false;
  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isHosteller = prefs.getBool("isHosteller") ?? false;
  }

  Future setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isHosteller", isHosteller);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5274EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${_authInstance.getUserName() ?? 'User'}',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              Image.asset(
                'assets/onBoardingLogo.png',
                width: double.infinity,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 8,
                                  color: (isHosteller)
                                      ? Colors.white
                                      : Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 60, horizontal: 10),
                        ),
                        onPressed: () async {
                          isHosteller = false;
                          await setPrefs();
                          setState(() {});
                        },
                        child: Column(children: [
                          Image.asset(
                            'assets/dayScholar.png',
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Day-Scholar',
                            style: TextStyle(
                                fontSize: 24, color: Color(0xFF5274EF)),
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
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 8,
                                      color: (isHosteller)
                                          ? Colors.blue
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              isHosteller = true;
                              await setPrefs();
                              setState(() {});
                            },
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
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                  child: Text(
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
