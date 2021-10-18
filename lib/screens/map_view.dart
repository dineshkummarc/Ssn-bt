import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Marker? marker;
  Circle? circle;
  late GoogleMapController _controller;
  static const LatLng _initialLocation = LatLng(12.75194333944987,
      80.20331063903828); //co-ordinates of ssn college by default

  void updateMarkerAndCircle() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/bus_top_icon.png");
    Uint8List imageData = byteData.buffer.asUint8List();
    LatLng latlng = const LatLng(12.8459, 80.2265);
    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: 0,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker);
      circle = Circle(
          circleId: const CircleId("bus"),
          radius: 20,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        updateMarkerAndCircle();
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: _initialLocation,
        zoom: 14.5,
      ),
      markers: Set.of((marker != null) ? [marker!] : []),
      circles: Set.of((circle != null) ? [circle!] : []),
    );
  }
}
