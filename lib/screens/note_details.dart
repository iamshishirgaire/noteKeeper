import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/screens/addNote.dart';
import 'package:loginui/screens/note_screen.dart';

// ignore: must_be_immutable
class NoteDetails extends StatefulWidget {
  Map<String, dynamic> note;
  NoteDetails({super.key, required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.note['title'],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.note['subtitle'],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Importance :",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.note["importance"],
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30)),
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AddNote(
                                title: "Edit Notes",
                                editNote: widget.note,
                              )));
                      final update = await FirebaseFirestore.instance
                          .collection('notes')
                          .doc(widget.note['id'])
                          .get();
                      final updatedData = update.data();
                      updatedData!['id'] = widget.note['id'];
                      widget.note = updatedData;
                      setState(() {});
                    },
                    child: const Text(
                      "Edit ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30)),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("notes")
                            .doc(widget.note["id"])
                            .delete()
                            .whenComplete(() => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const NoteListView())));
                      } on FirebaseException catch (e) {
                        debugPrint(e.message);
                      }
                    },
                    child: const Text(
                      "Delete",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
