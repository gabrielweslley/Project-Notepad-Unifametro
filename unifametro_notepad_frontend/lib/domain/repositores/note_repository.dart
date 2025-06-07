import 'package:unifametro_notepad_frontend/domain/entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<void> addNote({required Note note});
  Future<void> updateNote({required Note note});
  Future<void> deleteNote({required int id});
}
