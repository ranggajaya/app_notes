import 'package:app_note/db/database.dart';
import 'package:app_note/model/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_screen.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white10,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat.yMMMd().format(note.createdTime),
                        style: TextStyle(color: Colors.white54),
                      ),
                      SizedBox(height: 16),
                      Text(
                        note.description,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
