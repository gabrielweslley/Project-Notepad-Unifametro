import 'package:unifametro_notepad_frontend/domain/repositores/note_repository.dart';

class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<void> call(int id) => repository.deleteNote(id: id);
}
