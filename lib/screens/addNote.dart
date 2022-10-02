// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  String title;
  Map<String, dynamic>? editNote;
  AddNote({super.key, this.title = 'Add Note', this.editNote});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String _impController = "Medium";

  @override
  void initState() {
    if (widget.editNote != null) {
      _titleController.text = widget.editNote!["title"];
      _subtitleController.text = widget.editNote!["subtitle"];
      _impController = widget.editNote!["importance"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 50.0, bottom: 8.0, left: 20, right: 20),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Input your Title",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  hintText: "Input your Subtitle",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  RadioListTile(
                      title: const Text('High'),
                      value: "High",
                      groupValue: _impController,
                      onChanged: (s) {
                        setState(() {
                          _impController = s!;
                        });
                      }),
                  RadioListTile(
                      title: const Text('Medium'),
                      value: "Medium",
                      groupValue: _impController,
                      onChanged: (s) {
                        setState(() {
                          _impController = s!;
                        });
                      }),
                  RadioListTile(
                      title: const Text('Low'),
                      value: "Low",
                      groupValue: _impController,
                      onChanged: (s) {
                        setState(() {
                          _impController = s!;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30)),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        if (widget.editNote == null) {
                          await FirebaseFirestore.instance
                              .collection("notes")
                              .add({
                            "title": _titleController.text,
                            "subtitle": _subtitleController.text,
                            "importance": _impController,
                            'dateTime': FieldValue.serverTimestamp()
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        } else {
                          final updatedData = {
                            "title": _titleController.text,
                            "subtitle": _subtitleController.text,
                            "importance": _impController,
                            "updateAt": FieldValue.serverTimestamp()
                          };
                          await FirebaseFirestore.instance
                              .collection("notes")
                              .doc(widget.editNote!["id"])
                              .update(updatedData);
                          updatedData['id'] = widget.editNote!['id'];

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      } on FirebaseException catch (e) {
                        debugPrint(e.message);
                      }

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => const LoginUi()));
                    },
                    child: Text(
                      widget.editNote != null ? "Update Note" : "Add Note",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
