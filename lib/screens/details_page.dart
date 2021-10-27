import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/location_controller.dart';
import 'package:ssnbt/screens/select_route.dart';
import 'package:ssnbt/widgets/bottom_navbar.dart';
import 'package:ssnbt/widgets/details_card.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key}) : super(key: key);
  final _locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 50, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DetailsCard(),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => SelectRoute());
                  },
                  child: const Text(
                    'Change Route',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
