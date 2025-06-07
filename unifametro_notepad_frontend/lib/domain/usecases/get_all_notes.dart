import 'package:unifametro_notepad_frontend/domain/entities/note.dart';
import 'package:unifametro_notepad_frontend/domain/repositores/note_repository.dart';

class GetAllNotes {
  final NoteRepository repository;

  GetAllNotes(this.repository);

  Future<List<Note>> call() => repository.getAllNotes();
}
