import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ssnbt/controllers/location_controller.dart';
import 'package:ssnbt/widgets/bottom_navbar.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final _locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _locationController.mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                _locationController.latitude,
                _locationController.longitude,
              ),
            ),
          );
        },
        child: const Icon(Icons.gps_fixed),
      ),
      body: Obx(() {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _locationController.mapController = controller;
            _locationController.addMarkers();
            rootBundle.loadString('assets/retro_style.json').then(
                  (mapStyle) =>
                      _locationController.mapController.setMapStyle(mapStyle),
                );
            _locationController.startTracking();
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                _locationController.latitude, _locationController.longitude),
            zoom: 14,
          ),
          markers: _locationController.markers.value,
          circles: _locationController.circles.value,
          polylines: _locationController.polylines.value,
        );
      }),
    );
  }
}
