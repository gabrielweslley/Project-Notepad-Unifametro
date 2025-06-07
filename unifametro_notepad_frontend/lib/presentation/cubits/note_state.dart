part of 'note_cubit.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded(this.notes);
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}
