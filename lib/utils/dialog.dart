import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geotrackerapp/utils/auth.dart';
import 'package:geotrackerapp/utils/database.dart';
import 'package:provider/provider.dart';

Future<void> showMyDialog(BuildContext context) {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final _controller = TextEditingController();
        bool isFound = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Find Friend'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search by user email',
                      suffixIcon: isFound
                          ? const Icon(
                              Icons.done_sharp,
                              size: 34.0,
                              color: Colors.green,
                            )
                          : null,
                    ),
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              if (!isFound)
                TextButton(
                  child: const Text('Find'),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      bool user =
                          await FirestoreHandler(FirebaseFirestore.instance)
                              .checkUser(_controller.text);
                      setState(() {
                        isFound = user;
                      });
                    }
                  },
                ),
              if (isFound)
                TextButton(
                  child: const Text('Add friend'),
                  onPressed: () {
                    String? myEmail = context
                        .read<AuthenticationService>()
                        .currentAuthUser!
                        .email;
                    FirestoreHandler(FirebaseFirestore.instance)
                        .addFriend(_controller.text, myEmail);

                    Navigator.pop(context);
                  },
                ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      });
}
