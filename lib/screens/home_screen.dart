import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geotrackerapp/utils/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late Future<Position> _position;

  @override
  void initState() {
    _position = determinePosition();
    super.initState();
  }

  // getPosition() async {
  //   _position = determinePosition();
  //   _lat = _position.latitude;
  //   _long = _position.longitude;
  // }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(_lat, _long),
  //   zoom: 14.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Position>(
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
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
