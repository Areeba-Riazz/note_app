import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditNoteScreen extends StatefulWidget {
  final String? noteId; // If null, it's adding a new note. Otherwise, it's editing an existing note.

  const AddEditNoteScreen({Key? key, this.noteId}) : super(key: key);

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _fetchNoteDetails(widget.noteId!);
    }
  }

  // Fetch note details if editing an existing note
  void _fetchNoteDetails(String noteId) async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('notes').doc(noteId).get();
    if (doc.exists) {
      _titleController.text = doc['title'];
      _contentController.text = doc['content'];
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Save note to Firestore (either add or update)
  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      // You can show a message if any field is empty
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.noteId == null) {
        // Add a new note
        await FirebaseFirestore.instance.collection('notes').add({
          'title': _titleController.text,
          'content': _contentController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing note
        await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).update({
          'title': _titleController.text,
          'content': _contentController.text,
        });
      }
      // Pop back to the previous screen after saving
      Navigator.pop(context);
    } catch (e) {
      print('Error saving note: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Add Note' : 'Edit Note'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveNote,
                    child: Text(widget.noteId == null ? 'Add Note' : 'Update Note'),
                  ),
                ],
              ),
            ),
    );
  }
}
