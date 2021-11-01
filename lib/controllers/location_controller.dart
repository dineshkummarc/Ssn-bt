import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/models/route.dart';
import 'package:ssnbt/models/stop.dart';

class LocationController extends GetxController {
  final StorageController _storageController = Get.find();
  var markers = <Marker>{}.obs;
  var circles = <Circle>{}.obs;
  var polylines = <Polyline>{}.obs;
  var currentStatus = 0.obs;
  var totalDistance = 0.0.obs;
  var minutes = 0.obs;
  int driverNumber = 0;
  StreamSubscription? _locationSubscription;
  late GoogleMapController mapController;
  late double latitude;
  late double longitude;
  late double stopLatitude;
  late double stopLongitude;
  late BitmapDescriptor mapStopMarker;
  late BitmapDescriptor mapBusMarker;
  @override
  void onInit() {
    super.onInit();
    loadCustomMarkers();
    stopLatitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .latitude;
    stopLongitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .longitude;
    latitude = stopLatitude;
    longitude = stopLongitude;
  }

  void stopListening() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
  }

  void loadCustomMarkers() async {
    mapStopMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/signboard.png");
    mapBusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/busMarker.png");
  }

  void addMarkers() {
    List<Stop> stopsList =
        routesList[_storageController.routeIndex.value].stops;
    markers.clear();
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
  }

  void setPolylines() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    stopLatitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .latitude;
    stopLongitude = routesList[_storageController.routeIndex.value]
        .stops[_storageController.stopIndex.value]
        .longitude;
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['API_KEY']!,
      PointLatLng(latitude, longitude),
      PointLatLng(stopLatitude, stopLongitude),
    );
    if (polylineResult.status == "OK") {
      for (int i = 0; i < polylineResult.points.length; i++) {
        var point = polylineResult.points[i];
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      //calculate total distance
      totalDistance.value = 0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance.value += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      _calculateEstimatedTime();
      polylines.clear();
      polylines.add(Polyline(
        width: 5,
        zIndex: 1,
        polylineId: const PolylineId('navRoute'),
        color: Colors.blue,
        points: polylineCoordinates,
      ));
    }
  }

  void startTracking() async {
    _locationSubscription = FirebaseFirestore.instance
        .collection('location')
        .doc(routesList[_storageController.routeIndex.value].routeNumber)
        .snapshots()
        .listen((event) {
      latitude = event.get('latitude');
      longitude = event.get('longitude');
      currentStatus.value = event.get('currentStatus');
      driverNumber = event.get('driverNumber');
      if (currentStatus.value != 1) {
        polylines.clear();
        circles.clear();
        if (currentStatus.value == 2) {
          //toast message for breakdown
        }
        return;
      }
      if (markers.last.markerId.value == 'busMarker') {
        markers.remove(markers.last);
      }
      markers.add(
        Marker(
          markerId: const MarkerId('busMarker'),
          icon: mapBusMarker,
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
              title:
                  routesList[_storageController.routeIndex.value].routeNumber),
          position: LatLng(
            latitude,
            longitude,
          ),
        ),
      );
      circles.value = {
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
      setPolylines();
    });
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _calculateEstimatedTime() {
    num estimatedSpeed = 45;
    num estimatedTime = totalDistance / estimatedSpeed;
    minutes.value = (estimatedTime * 60).round();
  }
}
