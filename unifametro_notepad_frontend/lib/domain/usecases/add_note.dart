import 'package:unifametro_notepad_frontend/domain/entities/note.dart';
import 'package:unifametro_notepad_frontend/domain/repositores/note_repository.dart';

class AddNote {
  final NoteRepository repository;

  AddNote(this.repository);

  Future<void> call(Note note) => repository.addNote(note: note);
}
