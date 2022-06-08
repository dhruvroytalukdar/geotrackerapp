import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotrackerapp/utils/auth.dart';
import 'package:geotrackerapp/utils/database.dart';
import 'package:geotrackerapp/utils/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapComponent extends StatefulWidget {
  final String? targetEmail;
  const MapComponent({Key? key, required this.targetEmail}) : super(key: key);

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  late Future<Position> _position;
  late Timer _timer;

  @override
  void initState() {
    _position = determinePosition();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      Position temp = await determinePosition();
      String? email =
          context.read<AuthenticationService>().currentAuthUser!.email;
      FirestoreHandler(FirebaseFirestore.instance).updateMyPosition(
        GeoPoint(temp.latitude, temp.longitude),
        timer.tick.toString(),
        email,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream =
        FirebaseFirestore.instance
            .collection('location')
            .doc(widget.targetEmail ?? "abc")
            .snapshots();

    final Set<Marker> _markers = {};

    return FutureBuilder<Position>(
      future: _position,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: usersStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    firestoreSnapshot) {
              if (firestoreSnapshot.hasError) {
                return Text('Something went wrong');
              }

              if (firestoreSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Text("Loading");
              }
              final data = firestoreSnapshot.data!.data();
              _markers.add(
                Marker(
                  markerId: const MarkerId("home"),
                  position: LatLng(
                    snapshot.data!.latitude,
                    snapshot.data!.longitude,
                  ),
                ),
              );

              if (data != null) {
                _markers.add(
                  Marker(
                    markerId: const MarkerId("friend"),
                    position: LatLng(
                      data['position']!.latitude,
                      data['position']!.longitude,
                    ),
                  ),
                );
              }

              print("Help me + ${data.toString()} + ${widget.targetEmail}");
              return GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                    zoom: 17,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    //print("MARKER LENGTH ${_markers.length}");
                    if (_markers.length > 1) {
                      Future.delayed(
                          const Duration(seconds: 1),
                          () => controller.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                  _bounds(_markers), 20)));
                    }
                  });
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
