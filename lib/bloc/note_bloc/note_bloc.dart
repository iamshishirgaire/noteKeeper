import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/repository/note_repo.dart';

import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<AddNoteEvent>((event, emit) async {
      emit(NoteLoadingState());
      var result = await NoteRepo().addNote(event.note);
      if (result == true) {
        emit(NoteAddSuccessState());
      } else {
        emit(NoteAddFailureState());
      }
    });
    on<ReadNoteEvent>((event, emit) async {
      emit(NoteLoadingState());
      var result = await NoteRepo().getAllNotes();
      if (result.isNotEmpty) {
        emit(NoteReadSuccessState(result));
      } else {
        emit(NoteReadFailureState());
      }
    });
    on<DeleteNoteEvent>((event, emit) async {
      var result = await NoteRepo().deleteNote(event.note);
      if (result == true) {
        emit(NoteDeleteSuccessState());
      } else {
        emit(NoteDeleteFailureState());
      }
    });
    on<UpdateNoteEvent>((event, emit) async {
      var result = await NoteRepo().editNote(event.note);
      if (result == true) {
        emit(NoteUpdateSuccessState());
      } else {
        emit(NoteUpdateFailureState());
      }
    });
  }
}
