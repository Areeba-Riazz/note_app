import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a note to Firestore
  Future<void> addNote(Map<String, dynamic> noteData) async {
    try {
      await _db.collection('notes').add(noteData);
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // Fetch notes from Firestore
  Stream<List<Map<String, dynamic>>> getNotes() {
    return _db.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
}
