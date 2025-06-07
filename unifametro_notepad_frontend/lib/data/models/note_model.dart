import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final id =
        int.parse(Uri.parse(json['_links']['self']['href']).pathSegments.last);
    return NoteModel(
      id: id,
      title: json['titulo'],
      description: json['descricao'],
      createdAt: DateTime.parse(
          json['dataCriacao'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'titulo': title,
        'descricao': description,
        'dataCriacao': createdAt.toIso8601String(),
      };
}
