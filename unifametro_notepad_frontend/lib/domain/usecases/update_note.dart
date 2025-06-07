import 'package:unifametro_notepad_frontend/domain/entities/note.dart';
import 'package:unifametro_notepad_frontend/domain/repositores/note_repository.dart';

class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  Future<void> call(Note note) => repository.updateNote(note: note);
}
