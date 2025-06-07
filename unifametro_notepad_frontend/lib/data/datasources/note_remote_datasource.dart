import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/exceptions/server_exception.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> fetchNotes();
  Future<void> addNote({required NoteModel note});
  Future<void> updateNote({required NoteModel note});
  Future<void> deleteNote({required int id});
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final http.Client client;

  NoteRemoteDataSourceImpl(this.client);

  final String baseUrl = 'https://notepad-backend-mqb2.onrender.com/notas';
  @override
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final http.Response response =
          await client.get(Uri.parse('$baseUrl?page=0&size=100'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> notes = data['_embedded']['notas'];
        return notes.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        throw ServerException('Erro ${response.statusCode}');
      }
    } catch (_) {
      throw ServerException('Sem conexão com a internet ou erro de rede.');
    }
  }

  @override
  Future<void> addNote({required NoteModel note}) async {
    final http.Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()));
    if (response.statusCode != 201) {
      throw ServerException('Erro ao criar nota');
    }
  }

  @override
  Future<void> updateNote({required NoteModel note}) async {
    final http.Response response = await client.put(
        Uri.parse('$baseUrl/${note.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()));
    if (response.statusCode != 204) {
      throw ServerException('Erro ao atualizar nota');
    }
  }

  @override
  Future<void> deleteNote({required int id}) async {
    final http.Response response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 204) {
      throw ServerException('Erro ao deletar nota');
    }
  }
}

class MockNoteRemoteDataSource implements NoteRemoteDataSource {
  final List<NoteModel> _mockNotes = [];

  @override
  Future<List<NoteModel>> fetchNotes() async {
    return Future.value(_mockNotes);
  }

  @override
  Future<void> addNote({required NoteModel note}) async {
    _mockNotes.add(note);
  }

  @override
  Future<void> updateNote({required NoteModel note}) async {
    final index = _mockNotes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _mockNotes[index] = note;
    }
  }

  @override
  Future<void> deleteNote({required int id}) async {
    _mockNotes.removeWhere((note) => note.id == id);
  }
}
