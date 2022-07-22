import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHandler {
  final FirebaseFirestore _firestore;

  FirestoreHandler(this._firestore);

  updateMyPosition(GeoPoint position, String? timer, String? myEmail) async {
    try {
      await _firestore
          .collection("location")
          .doc(myEmail)
          .set({"position": position, "time": timer});
    } catch (e) {
      print(e.toString());
    }
  }

  addNewUser(String email) async {
    try {
      await _firestore
          .collection("user")
          .doc(email)
          .set({"email": email, "online": false});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setOnline(String email, bool value) async {
    try {
      await _firestore
          .collection("user")
          .doc(email)
          .set({"email": email, "online": value});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isOnline(String email) async {
    try {
      final rawData = await _firestore.collection("user").doc(email).get();
      final map = rawData.data();
      if (map != null) return map["online"];
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> checkUser(String email) async {
    try {
      final rawData = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      final data = rawData.docs;
      return data.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> updateValues(String me, String friend) async {
    try {
      final rawData = await _firestore.collection('friends').doc(me).get();
      final data = rawData.data();
      if (data == null) {
        await _firestore.collection('friends').doc(me).set({
          'friendlist': [friend],
        });
      } else {
        await _firestore.collection('friends').doc(me).update({
          'friendlist': FieldValue.arrayUnion([friend]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addFriend(String friend, String? me) async {
    await updateValues(me!, friend);
    await updateValues(friend, me);
  }
}
