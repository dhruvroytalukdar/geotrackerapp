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
      await _firestore.collection("user").add({"email": email});
    } catch (e) {
      print(e.toString());
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
