import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/screens/addNote.dart';

import 'note_details.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final List<Map<String, dynamic>> _notes = [];

  void _readData() async {
    _notes.clear();
    final data = await FirebaseFirestore.instance
        .collection('notes')
        .orderBy("dateTime", descending: true)
        .get();

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
        title: const Text("NoteKeeper "),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _readData();
        },
        child: _notes.isEmpty
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
                    background: Container(
                      color: Colors.red,
                    ),
                    key: ObjectKey(note["id"]),
                    onDismissed: (dir) async {
                      await FirebaseFirestore.instance
                          .collection("notes")
                          .doc(note["id"])
                          .delete();

                      // _readData();

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
                            await Navigator.of(context).push(MaterialPageRoute(
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
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(note['title']),
                          subtitle: Text(note['subtitle']),
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
