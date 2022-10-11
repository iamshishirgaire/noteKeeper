import 'package:loginui/models/note_model.dart';

abstract class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteReadSuccessState extends NoteState {
  final List<Note> note;
  NoteReadSuccessState(this.note);
}

class NoteReadFailureState extends NoteState {}

class NoteAddSuccessState extends NoteState {}

class NoteAddFailureState extends NoteState {}

class NoteDeleteSuccessState extends NoteState {}

class NoteDeleteFailureState extends NoteState {}

class NoteUpdateSuccessState extends NoteState {}

class NoteUpdateFailureState extends NoteState {}

class NoteInitial extends NoteState {}
