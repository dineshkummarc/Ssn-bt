import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/auth_controller.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/main.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/widgets/stop_card.dart';

class SelectStop extends StatelessWidget {
  SelectStop({Key? key}) : super(key: key);
  final StorageController _storageController = Get.find();
  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Select your Stop'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_authController.user != null) {
            Get.offAll(() => AuthWrapper());
          } else {
            _authController.signInWithGoogle();
          }
        },
        child: const Icon(Icons.navigate_next),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount:
            routesList[_storageController.routeIndex.value].stops.length - 1,
        itemBuilder: (context, index) {
          return Obx(() {
            return GestureDetector(
              onTap: () {
                _storageController.setStopIndex(index);
              },
              child: StopCard(
                stop: routesList[_storageController.routeIndex.value]
                    .stops[index],
                isSelected: _storageController.stopIndex.value == index,
              ),
            );
          });
        },
      ),
    );
  }
}
