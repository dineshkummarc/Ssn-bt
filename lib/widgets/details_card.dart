import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/location_controller.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/models/route.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsCard extends StatelessWidget {
  DetailsCard({Key? key}) : super(key: key);
  final LocationController _locationController = Get.find();
  final StorageController _storageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_bus),
                    Text(
                      ' - ${routesList[_storageController.routeIndex.value].routeNumber}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const Text(
                  'Current Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routesList[_storageController.routeIndex.value]
                      .busRegistrationNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    (_locationController.currentStatus.value == 0)
                        ? 'Idle'
                        : (_locationController.currentStatus.value == 1)
                            ? 'RUNNING'
                            : 'Breakdown',
                    style: TextStyle(
                      color: (_locationController.currentStatus.value == 0)
                          ? Colors.grey
                          : (_locationController.currentStatus.value == 1)
                              ? Colors.green
                              : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            if (_locationController.currentStatus.value == 1)
              Text(
                (_locationController.totalDistance < 0)
                    ? 'Distance Remaining - ${_locationController.totalDistance.value.toStringAsFixed(3)} m'
                    : 'Distance Remaining - ${_locationController.totalDistance.value.toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_locationController.currentStatus.value == 1)
              Text(
                'Expected Arrival  - ${_locationController.minutes.value} minutes',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            TextButton.icon(
              onPressed: () {
                launch("tel:${_locationController.driverNumber}");
              },
              icon: const Icon(Icons.call),
              label: const Text('Call Driver'),
              style: TextButton.styleFrom(
                primary: const Color(0xFF5274EF),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                launch(
                    "tel:${routesList[_storageController.routeIndex.value].inChargeNumber}");
              },
              icon: const Icon(Icons.call),
              label: const Text('Call Supervisor'),
              style: TextButton.styleFrom(
                primary: const Color(0xFF5274EF),
              ),
            ),
          ],
        );
      }),
    );
  }
}
