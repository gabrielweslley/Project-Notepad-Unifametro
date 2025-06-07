import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:unifametro_notepad_frontend/core/services/connectivity_service.dart';
import 'package:unifametro_notepad_frontend/presentation/view/note_form_page.dart';
import 'package:unifametro_notepad_frontend/presentation/view/note_list_page.dart';

import 'data/datasources/note_remote_datasource.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/entities/note.dart';
import 'domain/usecases/add_note.dart';
import 'domain/usecases/delete_note.dart';
import 'domain/usecases/get_all_notes.dart';
import 'domain/usecases/update_note.dart';
import 'presentation/cubits/note_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  final http.Client client = http.Client();
  final NoteRemoteDataSource datasource = NoteRemoteDataSourceImpl(client);
  // final NoteRemoteDataSource datasource = MockNoteRemoteDataSource();
  final NoteRepositoryImpl repository = NoteRepositoryImpl(datasource);
  final ConnectivityService connectivityService = ConnectivityService();

  runApp(MyApp(
    getAllNotes: GetAllNotes(repository),
    addNote: AddNote(repository),
    updateNote: UpdateNote(repository),
    deleteNote: DeleteNote(repository),
    connectivityService: connectivityService,
  ));
}

class MyApp extends StatelessWidget {
  final GetAllNotes getAllNotes;
  final AddNote addNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final ConnectivityService connectivityService;

  const MyApp({
    super.key,
    required this.getAllNotes,
    required this.addNote,
    required this.updateNote,
    required this.deleteNote,
    required this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteCubit(
        getAllNotes: getAllNotes,
        addNote: addNote,
        updateNote: updateNote,
        deleteNote: deleteNote,
        connectivityService: connectivityService,
      )..fetchNotes(),
      child: MaterialApp(
        title: 'Notas App',
        debugShowCheckedModeBanner: false,
        home: NoteListPage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        routes: {
          '/add': (context) => NoteFormPage(),
          '/edit': (context) {
            final note = ModalRoute.of(context)!.settings.arguments as Note;
            return NoteFormPage(note: note);
          },
        },
      ),
    );
  }
}
