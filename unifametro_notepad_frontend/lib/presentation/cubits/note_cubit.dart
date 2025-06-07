import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unifametro_notepad_frontend/core/exceptions/network_exception.dart';
import 'package:unifametro_notepad_frontend/core/services/connectivity_service.dart';

import '../../core/exceptions/server_exception.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_all_notes.dart';
import '../../domain/usecases/update_note.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final GetAllNotes getAllNotes;
  final AddNote addNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final ConnectivityService connectivityService;

  NoteCubit({
    required this.getAllNotes,
    required this.addNote,
    required this.updateNote,
    required this.deleteNote,
    required this.connectivityService,
  }) : super(NoteInitial());

  Future<void> _checkConnection() async {
    if (!await connectivityService.isConnected()) {
      throw NetworkException('Sem conexão com a internet');
    }
  }

  Future<void> fetchNotes() async {
    emit(NoteLoading());
    try {
      await _checkConnection();
      final List<Note> notes = await getAllNotes();
      emit(NoteLoaded(notes));
    } on NetworkException catch (e) {
      emit(NoteError(e.message));
    } on ServerException catch (e) {
      emit(NoteError('Erro do servidor: ${e.message}'));
    }
  }

  Future<void> createNote(Note note) async {
    try {
      await _checkConnection();
      await addNote(note);
      fetchNotes();
    } on NetworkException catch (e) {
      emit(NoteError(e.message));
    } on ServerException catch (e) {
      emit(NoteError('Erro: ${e.message}'));
    }
  }

  Future<void> editNote(Note note) async {
    try {
      await _checkConnection();
      await updateNote(note);
      fetchNotes();
    } on NetworkException catch (e) {
      emit(NoteError(e.message));
    } on ServerException catch (e) {
      emit(NoteError('Erro: ${e.message}'));
    }
  }

  Future<void> removeNote(int id) async {
    try {
      await _checkConnection();
      await deleteNote(id);
      fetchNotes();
    } on NetworkException catch (e) {
      emit(NoteError(e.message));
    } on ServerException catch (e) {
      emit(NoteError('Erro: ${e.message}'));
    }
  }
}
