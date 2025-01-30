import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';

class NoteViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _notes = [];

  List<Map<String, dynamic>> get notes => _notes;

  // Fetch notes from Firestore
  Future<void> fetchNotes() async {
    try {
      _firestoreService.getNotes().listen((data) {
        _notes = data;
        notifyListeners(); // Notify listeners to update UI
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  // Add a new note
  Future<void> addNote(Map<String, dynamic> noteData) async {
    await _firestoreService.addNote(noteData);
    fetchNotes(); // Refresh the list after adding a note
  }
}
