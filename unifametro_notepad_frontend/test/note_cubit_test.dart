import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:unifametro_notepad_frontend/core/services/connectivity_service.dart';
import 'package:unifametro_notepad_frontend/domain/entities/note.dart';
import 'package:unifametro_notepad_frontend/domain/usecases/add_note.dart';
import 'package:unifametro_notepad_frontend/domain/usecases/delete_note.dart';
import 'package:unifametro_notepad_frontend/domain/usecases/get_all_notes.dart';
import 'package:unifametro_notepad_frontend/domain/usecases/update_note.dart';
import 'package:unifametro_notepad_frontend/presentation/cubits/note_cubit.dart';

class MockGetAllNotes extends Mock implements GetAllNotes {
  @override
  Future<List<Note>> call() => super.noSuchMethod(
        Invocation.method(#call, []),
        returnValue: Future.value(<Note>[]),
        returnValueForMissingStub: Future.value(<Note>[]),
      );
}

class MockAddNote extends Mock implements AddNote {
  @override
  Future<void> call(Note note) => super.noSuchMethod(
        Invocation.method(#call, [note]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

class MockUpdateNote extends Mock implements UpdateNote {
  @override
  Future<void> call(Note note) => super.noSuchMethod(
        Invocation.method(#call, [note]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

class MockDeleteNote extends Mock implements DeleteNote {
  @override
  Future<void> call(int id) => super.noSuchMethod(
        Invocation.method(#call, [id]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

class MockConnectivityService extends Mock implements ConnectivityService {
  @override
  Future<bool> isConnected() => super.noSuchMethod(
        Invocation.method(#isConnected, []),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(true),
      );

  void setConnectionStatus(bool status) {
    when(isConnected()).thenAnswer((_) async => status);
  }
}

void main() {
  late NoteCubit cubit;
  late MockGetAllNotes getAll;
  late MockAddNote add;
  late MockUpdateNote update;
  late MockDeleteNote delete;
  late MockConnectivityService connectivity;

  setUp(() {
    getAll = MockGetAllNotes();
    add = MockAddNote();
    update = MockUpdateNote();
    delete = MockDeleteNote();
    connectivity = MockConnectivityService();
    cubit = NoteCubit(
      getAllNotes: getAll,
      addNote: add,
      updateNote: update,
      deleteNote: delete,
      connectivityService: connectivity,
    );
  });

  final testNote = Note(
      id: 1,
      title: 'Test',
      description: 'Test desc',
      createdAt: DateTime.now());

  test('emite NoteLoaded ao buscar notas com sucesso', () async {
    when(connectivity.isConnected()).thenAnswer((_) async => true);
    when(getAll.call()).thenAnswer((_) async => [testNote]);

    await cubit.fetchNotes();

    expect(cubit.state, isA<NoteLoaded>());
    expect((cubit.state as NoteLoaded).notes, [testNote]);
  });

  test('emite NoteError ao buscar notas sem internet', () async {
    when(connectivity.isConnected()).thenAnswer((_) async => false);

    await cubit.fetchNotes();

    expect(cubit.state, isA<NoteError>());
    expect((cubit.state as NoteError).message, 'Sem conexão com a internet');
  });

  test('emite NoteError ao criar nota sem internet', () async {
    when(connectivity.isConnected()).thenAnswer((_) async => false);

    await cubit.createNote(testNote);

    expect(cubit.state, isA<NoteError>());
    expect((cubit.state as NoteError).message, 'Sem conexão com a internet');
  });

  test('emite NoteError ao editar nota sem internet', () async {
    when(connectivity.isConnected()).thenAnswer((_) async => false);

    await cubit.editNote(testNote);

    expect(cubit.state, isA<NoteError>());
    expect((cubit.state as NoteError).message, 'Sem conexão com a internet');
  });

  test('emite NoteError ao remover nota sem internet', () async {
    when(connectivity.isConnected()).thenAnswer((_) async => false);

    await cubit.removeNote(1);

    expect(cubit.state, isA<NoteError>());
    expect((cubit.state as NoteError).message, 'Sem conexão com a internet');
  });
}
