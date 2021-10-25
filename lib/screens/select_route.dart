import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/services/authentication_service.dart';
import 'package:ssnbt/widgets/route_card.dart';

class SelectRoute extends StatefulWidget {
  const SelectRoute({Key? key}) : super(key: key);

  @override
  State<SelectRoute> createState() => _SelectRouteState();
}

class _SelectRouteState extends State<SelectRoute> {
  final _authInstance = AuthenticationService();
  int selectedRouteIndex = 0;
  bool _isLoading = false;
  Future signInWithGoogle() async {
    dynamic result = await _authInstance.signInWithGoogle();
    if (result == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
                title: const Text("Invalid Login"),
                content: const Text("Please Log in with ssn mail id"),
                actions: [
                  TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        signInWithGoogle();
                      }),
                ],
              ));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Select your route'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setInt('selectedRouteIndex', selectedRouteIndex);
          await signInWithGoogle();
        },
        child: const Icon(Icons.navigate_next),
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: routesList.length,
              itemBuilder: (context, index) {
                var route = routesList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRouteIndex = index;
                    });
                  },
                  child: RouteCard(
                    routeNumber: route.routeNumber,
                    stops: route.stops,
                    isSelected: selectedRouteIndex == index,
                  ),
                );
              },
            ),
    );
  }
}
