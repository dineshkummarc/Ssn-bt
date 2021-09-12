import 'package:flutter/material.dart';
import 'package:ssnbt/screens/DetailsPage.dart';
import 'package:ssnbt/screens/LostFound.dart';
import 'package:ssnbt/screens/MapView.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  List<Widget> _pages = [MapView(), DetailsPage(), LostFound()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentPage,
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on_rounded), label: "Location"),
            BottomNavigationBarItem(
                icon: Icon(Icons.business_center), label: "LostFound")
          ]),
      body: //IndexedStack(index: _currentPage, children: _pages),//old page state is saved
          _pages[_currentPage],
    );
  }
}
