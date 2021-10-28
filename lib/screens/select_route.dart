import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/screens/select_stop.dart';
import 'package:ssnbt/widgets/route_card.dart';

class SelectRoute extends StatelessWidget {
  SelectRoute({Key? key}) : super(key: key);
  final StorageController _storageController = Get.find();
  @override
  Widget build(BuildContext context) {
    _storageController.setStopIndex(0);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Select your route'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SelectStop());
        },
        child: const Icon(Icons.navigate_next),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: routesList.length,
        itemBuilder: (context, index) {
          var route = routesList[index];
          return Obx(() {
            return GestureDetector(
              onTap: () {
                _storageController.setRouteIndex(index);
              },
              child: RouteCard(
                routeNumber: route.routeNumber,
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
