import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/screens/details_page.dart';
import 'package:ssnbt/screens/home.dart';
import 'package:ssnbt/screens/lost_found.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        if (index == 0) {
          Get.off(() => Home(), transition: Transition.fadeIn);
        } else if (index == 1) {
          Get.off(() => DetailsPage(), transition: Transition.fadeIn);
        } else if (index == 2) {
          Get.off(() => LostFound(), transition: Transition.fadeIn);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded), label: "Location"),
        BottomNavigationBarItem(
            icon: Icon(Icons.business_center), label: "LostFound"),
      ],
    );
  }
}
