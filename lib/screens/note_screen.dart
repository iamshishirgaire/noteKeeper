import 'package:flutter/material.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final _count = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("    NoteKeeper"),
      ),
      body: ListView.builder(
        itemCount: _count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin:
                const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
            child: ListTile(
              leading: CircleAvatar(
                child: Text("${index + 1}"),
              ),
              title: const Text("Title"),
              subtitle: const Text("Sub Title"),
              trailing: Column(
                children: const [Text("2078/10/12"), Text("5:30 A.M.")],
              ),
            ),
          );
        },
      ),
    );
  }
}
