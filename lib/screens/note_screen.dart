import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/screens/addNote.dart';
import 'package:loginui/screens/note_details.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final List<Map<String, dynamic>> _notes = [];

  void _readData() async {
    _notes.clear();
    final data = await FirebaseFirestore.instance.collection('notes').get();
    for (var i in data.docs) {
      final jsonData = i.data();
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
              .push(MaterialPageRoute(builder: (_) => const AddNote()));
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
        child: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (BuildContext context, int index) {
            final note = _notes[index];
            return Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 5, right: 10),
              child: ListTile(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => NoteDetails(
                            note: note,
                          )));
                },
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(note['title']),
                subtitle: Text(note['subtitle']),
                trailing: Column(
                  children: const [Text("2078/10/12"), Text("5:30 A.M.")],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
