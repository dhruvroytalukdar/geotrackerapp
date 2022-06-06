import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotrackerapp/utils/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({Key? key}) : super(key: key);

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  late Future<Position> _position;

  @override
  void initState() {
    _position = determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _position,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.latitude,
                snapshot.data!.longitude,
              ),
              zoom: 17,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("home"),
                position: LatLng(
                  snapshot.data!.latitude,
                  snapshot.data!.longitude,
                ),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
