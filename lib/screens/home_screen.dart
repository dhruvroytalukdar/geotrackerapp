import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geotrackerapp/components/home_screen/map_component.dart';
import 'package:geotrackerapp/components/home_screen/content_section.dart';
import 'package:geotrackerapp/utils/auth.dart';
import 'package:geotrackerapp/utils/dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? friendEmail;

  @override
  Widget build(BuildContext context) {
    final myEmail =
        context.read<AuthenticationService>().currentAuthUser!.email;
    Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream =
        FirebaseFirestore.instance
            .collection('friends')
            .doc(myEmail)
            .snapshots();

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showMyDialog(context);
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 28,
                    ),
                  ),
                ],
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: documentStream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  return Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListView(
                        children:
                            data['friendlist'].map<Widget>((dynamic names) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                names,
                                style: const TextStyle(
                                  fontSize: 19.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    friendEmail = names;
                                  });
                                },
                                child: const Text(
                                  "Track",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          MapComponent(targetEmail: friendEmail),
          ContentSection(
            scaffoldKey: _scaffoldKey,
          ),
        ],
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
