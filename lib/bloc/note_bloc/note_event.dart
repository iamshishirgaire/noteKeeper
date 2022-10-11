import 'package:loginui/models/note_model.dart';

abstract class NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final Note note;
  AddNoteEvent(this.note);
}

class DeleteNoteEvent extends NoteEvent {
  final Note note;
  DeleteNoteEvent(this.note);
}

class ReadNoteEvent extends NoteEvent {}

class UpdateNoteEvent extends NoteEvent {
  final Note note;
  UpdateNoteEvent(this.note);
}
