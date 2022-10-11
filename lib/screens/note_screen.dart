import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/note_bloc/note_event.dart';
import 'package:loginui/bloc/theme_bloc/theme_bloc.dart';
import 'package:loginui/bloc/theme_bloc/theme_event.dart';
import 'package:loginui/screens/add_note.dart';
import 'package:loginui/screens/user_profile.dart';

import '../bloc/note_bloc/note_bloc.dart';
import '../bloc/note_bloc/note_state.dart';
import 'note_details.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc()..add(ReadNoteEvent()),
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteDeleteSuccessState || state is NoteAddSuccessState) {
            BlocProvider.of<NoteBloc>(context).add(ReadNoteEvent());
          }
        },
        builder: (context, state) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AddNote()));
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<NoteBloc>(context).add(ReadNoteEvent());
                },
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<ThemeBloc>(context)
                            .add(ThemeModeToggleEvent());
                      },
                      icon: const Icon(Icons.dark_mode)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UserProfile()));
                      },
                      icon: const Icon(Icons.account_circle_rounded)),
                ],
                title: Text((FirebaseAuth.instance.currentUser!.displayName) ??
                    "NoteKeeper"),
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<NoteBloc>(context).add(ReadNoteEvent());
                  },
                  child: state is NoteLoadingState
                      ? const Center(
                          child: Text(
                          "Fetching Notes.....",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ))
                      : state is NoteReadSuccessState && state.note.isEmpty
                          ? const Center(
                              child: Text(
                              "No Notes Found.",
                              style: TextStyle(fontSize: 20),
                            ))
                          : state is NoteReadSuccessState &&
                                  state.note.isNotEmpty
                              ? ListView.builder(
                                  itemCount: state.note.length,
                                  itemBuilder: (BuildContext _, int index) {
                                    final note = state.note[index];
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
                                      key: ObjectKey(note.id),
                                      onDismissed: (dir) async {
                                        // ignore: use_build_context_synchronously
                                        context
                                            .read<NoteBloc>()
                                            .add(DeleteNoteEvent(note));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text("Note Deleted"),
                                            action: SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  context
                                                      .read<NoteBloc>()
                                                      .add(AddNoteEvent(note));
                                                }),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            top: 10,
                                            bottom: 5,
                                            right: 10),
                                        child: ListTile(
                                            onTap: () async {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          NoteDetails(
                                                            note: note,
                                                          )));
                                              // ignore: use_build_context_synchronously
                                              BlocProvider.of<NoteBloc>(context)
                                                  .add(ReadNoteEvent());
                                            },
                                            leading: CircleAvatar(
                                              backgroundColor: note
                                                          .importance ==
                                                      "High"
                                                  ? Colors.red
                                                  : note.importance == "Medium"
                                                      ? Colors.amber
                                                      : Colors.green,
                                              child: Text("${index + 1}",
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            title: Text(
                                              note.title,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            subtitle: Text(
                                              note.subtitle,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            trailing:
                                                Builder(builder: (context) {
                                              final dateTime = note.dateTime;
                                              final date = dateTime
                                                  .toString()
                                                  .split(' ')[0];
                                              final time = dateTime
                                                  .toString()
                                                  .split(' ')[1]
                                                  .split('.')
                                                  .first;

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(date),
                                                  Text(time)
                                                ],
                                              );
                                            })),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                  "No notes Found.",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ))));
        },
      ),
    );
  }
}
