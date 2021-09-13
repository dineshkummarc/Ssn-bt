import 'package:flutter/material.dart';
import 'package:ssnbt/screens/details_page.dart';
import 'package:ssnbt/screens/lost_found.dart';
import 'package:ssnbt/screens/map_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  final List<Widget> _pages = [const MapView(), const DetailsPage(), const LostFound()];
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
          items: const [
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
