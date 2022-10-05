import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginui/screens/helper/note_class.dart';

class NoteServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Note>> getAllNotes() async {
    final data = await firebaseFirestore
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

  Future<String> addNote(Note note) async {
    try {
      await firebaseFirestore.collection("notes").add(note.toJson());
      return "Sucess";
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> editNote(Note note) async {
    try {
      final data = note.toJson();

      await firebaseFirestore.collection("notes").doc(note.id).set(data);
      return "Sucess";
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }
}
