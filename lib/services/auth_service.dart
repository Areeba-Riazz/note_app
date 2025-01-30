import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Add a new note
  Future<void> addNote(Note note) async {
    await notesCollection.doc(note.id).set(note.toMap());
  }

  // Update a note
  Future<void> updateNote(Note note) async {
    await notesCollection.doc(note.id).update(note.toMap());
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await notesCollection.doc(noteId).delete();
  }

  // Fetch notes as a stream
  Stream<List<Note>> getNotes() {
    return notesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
