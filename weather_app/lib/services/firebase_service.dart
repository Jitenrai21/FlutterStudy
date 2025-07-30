import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _uid = FirebaseAuth.instance.currentUser!.uid;

  static Future<void> addCity(String city) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(city)
        .set({'name': city, 'timestamp': FieldValue.serverTimestamp()});
  }

  static Future<void> removeCity(String city) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(city)
        .delete();
  }

  static Stream<QuerySnapshot> getFavoriteCities() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .snapshots();
  }
}
