import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginui/screens/add_note.dart';
import 'package:loginui/screens/helper/note_class.dart';
import 'package:loginui/screens/helper/note_services.dart';
import 'package:loginui/screens/user_profile.dart';
import 'package:lottie/lottie.dart';

import 'note_details.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  bool isLoaded = false;
  //final List<Map<String, dynamic>> _notes = [];
  List<Note> _notes = [];

  Future _readData() async {
    _notes.clear();
    _notes = await NoteServices().getAllNotes();

    await Future.delayed(const Duration(seconds: 1));
    isLoaded = true;

    setState(() {});
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddNote()));
          _readData();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UserProfile()));
              },
              icon: const Icon(Icons.account_circle_rounded))
        ],
        title: Text(
            (FirebaseAuth.instance.currentUser!.displayName) ?? "NoteKeeper"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _readData();
        },
        child: !isLoaded
            ? Center(child: Lottie.asset("assets/notesLoading.json"))
            : _notes.isEmpty
                ? const Center(
                    child: Text(
                    "No Notes Found.",
                    style: TextStyle(fontSize: 20),
                  ))
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final note = _notes[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 250),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        key: ObjectKey(_notes[0].id),
                        onDismissed: (dir) async {
                          await FirebaseFirestore.instance
                              .collection("notes")
                              .doc(note.id.toString())
                              .delete();

                          // _readData();

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Note Deleted"),
                              action: SnackBarAction(
                                  label: "Undo",
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("notes")
                                        .doc(note.id.toString())
                                        .set(note.toJson());
                                    _readData();
                                  }),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 5, right: 10),
                          child: ListTile(
                              onTap: () async {
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => NoteDetails(
                                              note: note,
                                            )));

                                _readData();
                              },
                              leading: CircleAvatar(
                                backgroundColor: note.importance == "High"
                                    ? Colors.red
                                    : note.importance == "Medium"
                                        ? Colors.amber
                                        : Colors.green,
                                child: Text("${index + 1}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              title: Text(
                                note.title,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Text(
                                note.subtitle,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: Builder(builder: (context) {
                                final dateTime = note.dateTime;
                                final date = dateTime.toString().split(' ')[0];
                                final time = dateTime
                                    .toString()
                                    .split(' ')[1]
                                    .split('.')
                                    .first;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [Text(date), Text(time)],
                                );
                              })),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
