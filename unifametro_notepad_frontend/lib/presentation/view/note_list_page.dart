import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:unifametro_notepad_frontend/domain/entities/note.dart';

import '../cubits/note_cubit.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Notas')),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final Note note = state.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.description),
                      SizedBox(height: 4),
                      Text(
                        'Criado em: ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(note.createdAt)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        context.read<NoteCubit>().removeNote(note.id),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, '/edit', arguments: note),
                );
              },
            );
          } else if (state is NoteError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff04401E),
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
