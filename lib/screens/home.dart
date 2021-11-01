import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ssnbt/controllers/location_controller.dart';
import 'package:ssnbt/screens/lost_found.dart';
import 'package:ssnbt/screens/select_route.dart';
import 'package:ssnbt/widgets/details_card.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final _locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _locationController.mapController = controller;
                rootBundle.loadString('assets/retro_style.json').then(
                      (mapStyle) => _locationController.mapController
                          .setMapStyle(mapStyle),
                    );
                _locationController.addMarkers();
                _locationController.startTracking();
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(_locationController.latitude,
                    _locationController.longitude),
                zoom: 14,
              ),
              markers: _locationController.markers.value,
              circles: _locationController.circles.value,
              polylines: _locationController.polylines.value,
            );
          }),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 5,
                    bottom: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: Icon(Icons.expand_less)),
                      DetailsCard(),
                      const SizedBox(height: 20),
                      if (_locationController.currentStatus.value == 1)
                        Container(
                          color: Colors.red,
                        ),
                      //stops view
                      const Text("Want to Track a Different Route?"),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10, bottom: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            _locationController.stopListening();
                            Get.offAll(() => SelectRoute());
                          },
                          child: const Text("Change Route"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const Text("Lost or Misplaced Something?"),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => LostFound(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: const Text("Report Lost Item"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
