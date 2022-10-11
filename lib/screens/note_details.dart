import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/note_bloc/note_event.dart';
import 'package:loginui/screens/add_note.dart';

import '../bloc/note_bloc/note_bloc.dart';
import '../bloc/note_bloc/note_state.dart';
import '../models/note_model.dart';

class NoteDetails extends StatefulWidget {
  Note note;
  NoteDetails({super.key, required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(),
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteDeleteSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
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
                    widget.note.title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.note.subtitle,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w300),
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
                    widget.note.importance,
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        color: const Color.fromARGB(255, 108, 99, 255),
                        textColor: Colors.white,
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AddNote(
                                    title: "Edit Notes",
                                    editNote: widget.note,
                                  )));
                          final update = await FirebaseFirestore.instance
                              .collection('notes')
                              .doc(widget.note.id.toString())
                              .get();
                          final updatedData = update.data();
                          updatedData!['id'] = widget.note.id;
                          widget.note = Note.fromJson(updatedData);
                          setState(() {});
                        },
                        child: const Text(
                          "Edit ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      MaterialButton(
                        textColor: Colors.white,
                        color: const Color.fromARGB(255, 108, 99, 255),
                        onPressed: () {
                          BlocProvider.of<NoteBloc>(context)
                              .add(DeleteNoteEvent(widget.note));
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
