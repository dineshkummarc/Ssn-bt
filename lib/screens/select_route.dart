import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/screens/select_stop.dart';
import 'package:ssnbt/widgets/routes_card.dart';

class SelectRoute extends StatelessWidget {
  SelectRoute({Key? key}) : super(key: key);
  final StorageController _storageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Select your route',
          style: TextStyle(
            color: Color(0xFF5B7B92),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[600],
        onPressed: () {
          Get.to(() => SelectStop(), transition: Transition.zoom);
        },
        child: const Icon(Icons.navigate_next),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: routesList.length,
        itemBuilder: (context, index) {
          var route = routesList[index];
          return Obx(() {
            return GestureDetector(
              onTap: () {
                _storageController.setRouteIndex(index);
                _storageController.setStopIndex(0);
              },
              child: RouteCard(
                routeNumber: route.routeNumber,
                licenseNumber: route.busRegistrationNumber,
                stops: route.stops,
                isSelected: _storageController.routeIndex.value == index,
              ),
            );
          });
        },
      ),
    );
  }
}
