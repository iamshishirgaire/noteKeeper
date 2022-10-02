import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginui/screens/add_note.dart';
import 'package:loginui/screens/login.dart';
import 'package:lottie/lottie.dart';

import 'note_details.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  bool isLoaded = false;
  final List<Map<String, dynamic>> _notes = [];

  void _readData() async {
    _notes.clear();

    final data = await FirebaseFirestore.instance
        .collection('notes')
        .orderBy("dateTime", descending: true)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    await Future.delayed(const Duration(seconds: 1));
    isLoaded = true;

    for (var i in data.docs) {
      final jsonData = i.data();
      jsonData.addAll({'id': i.id});
      _notes.add(jsonData);
    }
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginUi()),
                  ((route) => false));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        title: Text(
            (FirebaseAuth.instance.currentUser!.displayName) ?? "NoteKeeper"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _readData();
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
                        key: ObjectKey(note["id"]),
                        onDismissed: (dir) async {
                          await FirebaseFirestore.instance
                              .collection("notes")
                              .doc(note["id"])
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
                                        .doc(note["id"])
                                        .set(note);
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
                                backgroundColor: note["importance"] == "High"
                                    ? Colors.red
                                    : note["importance"] == "Medium"
                                        ? Colors.amber
                                        : Colors.green,
                                child: Text("${index + 1}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              title: Text(
                                note['title'],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Text(
                                note['subtitle'],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: Builder(builder: (context) {
                                final dateTime = note['dateTime'] as Timestamp;
                                final date =
                                    dateTime.toDate().toString().split(' ')[0];
                                final time = dateTime
                                    .toDate()
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
