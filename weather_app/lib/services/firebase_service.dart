import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static Future<void> addCity(String city) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _db
        .collection('users')
        .doc(_uid)
        .collection('weatherPreferences') // Use weatherPreferences
        .doc(city)
        .set({
      'name': city,
      'userId': _uid, // Add userId for security rules
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removeCity(String city) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _db
        .collection('users')
        .doc(_uid)
        .collection('weatherPreferences') // Use weatherPreferences
        .doc(city)
        .delete();
  }

  static Stream<QuerySnapshot> getFavoriteCities() {
    if (_uid == null) return Stream.empty();
    return _db
        .collection('users')
        .doc(_uid)
        .collection('weatherPreferences') // Use weatherPreferences
        .snapshots();
  }
}