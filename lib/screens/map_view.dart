import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/models/stop.dart';
import 'package:ssnbt/widgets/bottom_navbar.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final StorageController _storageController = Get.find();
  var markers = <Marker>{};
  var circles = <Circle>{};
  late double latitude;
  late double longitude;
  late BitmapDescriptor mapStopMarker;
  late BitmapDescriptor mapBusMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarkers();
    latitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .latitude;
    longitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .longitude;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void addMarkers() {
    List<Stop> stopsList =
        routesList[_storageController.routeIndex.value].stops;
    for (int i = 0; i < stopsList.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(stopsList[i].stopName),
          position: LatLng(stopsList[i].latitude, stopsList[i].longitude),
          icon: mapStopMarker,
          infoWindow: InfoWindow(
              title: stopsList[i].stopName,
              snippet:
                  '${stopsList[i].time.hour}:${stopsList[i].time.minute} AM'),
        ),
      );
    }
    setState(() {});
  }

  void startTracking() {
    FirebaseFirestore.instance
        .collection('location')
        .doc('${_storageController.routeIndex.value}')
        .snapshots()
        .listen((event) {
      latitude = event.get('latitude');
      longitude = event.get('longitude');
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('busMarker'),
            icon: mapBusMarker,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(
                title: routesList[_storageController.routeIndex.value]
                    .routeNumber),
            position: LatLng(
              latitude,
              longitude,
            ),
          ),
        );
        circles = {
          Circle(
            radius: 50,
            zIndex: 1,
            strokeWidth: 5,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.5),
            circleId: const CircleId('busLocation'),
            center: LatLng(
              latitude,
              longitude,
            ),
          )
        };
      });
    });
  }

  void setCustomMarkers() async {
    mapStopMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/signboard.png");
    mapBusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/busMarker.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                latitude,
                longitude,
              ),
            ),
          );
        },
        child: const Icon(Icons.gps_fixed),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          addMarkers();
          rootBundle.loadString('assets/retro_style.json').then(
                (mapStyle) => mapController.setMapStyle(mapStyle),
              );
          startTracking();
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14,
        ),
        markers: markers,
        circles: circles,
      ),
    );
  }
}
