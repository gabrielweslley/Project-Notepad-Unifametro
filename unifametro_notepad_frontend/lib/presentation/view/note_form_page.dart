import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/note.dart';
import '../cubits/note_cubit.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;

  const NoteFormPage({super.key, this.note});

  @override
  _NoteFormPageState createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _selectedDate = widget.note!.createdAt;
      _dateController.text =
          DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(_selectedDate);
    } else {
      _dateController.text =
          DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(_selectedDate);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('pt', 'BR'),
          child: child,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Localizations.override(
            context: context,
            locale: const Locale('pt', 'BR'),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text =
              DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(_selectedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Nota' : 'Nova Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe um título' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe uma descrição' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data e Hora',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Selecione uma data e hora' : null,
              ),
              SizedBox(height: 20),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff04401E),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final note = Note(
                      id: widget.note?.id ?? 0,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      createdAt: _selectedDate,
                    );
                    isEdit
                        ? context.read<NoteCubit>().editNote(note)
                        : context.read<NoteCubit>().createNote(note);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  isEdit ? 'Atualizar' : 'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
