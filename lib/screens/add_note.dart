import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/note_bloc/note_event.dart';

import '../bloc/note_bloc/note_bloc.dart';
import '../bloc/note_bloc/note_state.dart';
import '../models/note_model.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  String title;
  Note? editNote;
  AddNote({super.key, this.title = 'Add Note', this.editNote});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String _impController = "Medium";
  final _formController = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.editNote != null) {
      _titleController.text = widget.editNote!.title;
      _subtitleController.text = widget.editNote!.subtitle;
      _impController = widget.editNote!.importance;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(),
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocProvider(
            create: (context) => NoteBloc(),
            child: BlocConsumer<NoteBloc, NoteState>(
              listener: (context, state) {
                if (state is NoteUpdateSuccessState) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.title),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, bottom: 8.0, left: 20, right: 20),
                      child: Form(
                        key: _formController,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Title must not be empty";
                                }
                              },
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: "Input your Title",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2)),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Subtitle must not be empty";
                                }
                              },
                              controller: _subtitleController,
                              decoration: const InputDecoration(
                                hintText: "Input your Subtitle",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2)),
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
                              child: MaterialButton(
                                color: const Color.fromARGB(255, 108, 99, 255),
                                textColor: Colors.white,
                                onPressed: () {
                                  if (_formController.currentState!
                                      .validate()) {
                                    if (widget.editNote == null) {
                                      final note = Note(
                                          dateTime: DateTime.now(),
                                          importance: _impController,
                                          title: _titleController.text,
                                          userId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          subtitle: _subtitleController.text);
                                      BlocProvider.of<NoteBloc>(context)
                                          .add(AddNoteEvent(note));

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    } else {
                                      Note updatedNote = Note(
                                          dateTime: widget.editNote!.dateTime,
                                          title: _titleController.text,
                                          subtitle: _subtitleController.text,
                                          importance: _impController,
                                          id: widget.editNote!.id,
                                          userId: widget.editNote!.userId
                                              .toString());

                                      BlocProvider.of<NoteBloc>(context)
                                          .add(UpdateNoteEvent(updatedNote));
                                    }
                                  }

                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (_) => const LoginUi()));
                                },
                                child: Text(
                                  widget.editNote != null
                                      ? "Update Note"
                                      : "Add Note",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
