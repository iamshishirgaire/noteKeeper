import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String _impController = "Medium";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Notes"),
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
                        final addnote = await FirebaseFirestore.instance
                            .collection("notes")
                            .add({
                          "title": _titleController.text,
                          "subtitle": _subtitleController.text,
                          "importance": _impController,
                        });
                        Navigator.of(context).pop();
                      } on FirebaseException catch (e) {
                        debugPrint(e.message);
                      }

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => const LoginUi()));
                    },
                    child: const Text(
                      "Add Note",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
