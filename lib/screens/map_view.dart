import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(12.75194333944987,
      80.20331063903828); //co-ordinates of ssn college by default
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: _center,
        zoom: 14.5,
      ),
    );
  }
}
