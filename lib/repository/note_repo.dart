import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginui/models/note_model.dart';

class NoteRepo {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<List<Note>> getAllNotes() async {
    final data = await firebase
        .collection('notes')
        .orderBy("dateTime", descending: true)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<Note> notes = [];
    for (var i in data.docs) {
      final jsonData = i.data();
      jsonData.addAll({'id': i.id});
      notes.add(Note.fromJson(jsonData));
    }
    return notes;
  }

  Future<bool> addNote(Note note) async {
    try {
      await firebase.collection("notes").add(note.toJson());
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> editNote(Note note) async {
    try {
      final data = note.toJson();

      await firebase.collection("notes").doc(note.id).set(data);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> undoNote(Note undoNote) async {
    try {
      final data = undoNote.toJson();
      await firebase.collection("notes").doc(undoNote.id).set(data);
      return true;
    } on FirebaseException catch (_) {
      return (false);
    }
  }

  Future<bool> deleteNote(delNote) async {
    try {
      await firebase.collection("notes").doc(delNote.id).delete();
      return true;
    } on FirebaseException catch (_) {
      return (false);
    }
  }
}
