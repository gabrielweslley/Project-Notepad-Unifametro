import 'package:unifametro_notepad_frontend/domain/repositores/note_repository.dart';

import '../../domain/entities/note.dart';
import '../datasources/note_remote_datasource.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Note>> getAllNotes() async {
    return await remoteDataSource.fetchNotes();
  }

  @override
  Future<void> addNote({required Note note}) async {
    final model = NoteModel(
        id: note.id,
        title: note.title,
        description: note.description,
        createdAt: note.createdAt);
    await remoteDataSource.addNote(note: model);
  }

  @override
  Future<void> updateNote({required Note note}) async {
    final model = NoteModel(
        id: note.id,
        title: note.title,
        description: note.description,
        createdAt: note.createdAt);
    await remoteDataSource.updateNote(note: model);
  }

  @override
  Future<void> deleteNote({required int id}) async {
    await remoteDataSource.deleteNote(id: id);
  }
}
