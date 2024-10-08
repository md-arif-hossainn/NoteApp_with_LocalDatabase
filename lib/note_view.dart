import 'package:flutter/material.dart';
import 'node_model.dart';
import 'note_database.dart';
import 'note_details_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  List<NoteModel> notes = [];

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  dispose() {
    noteDatabase.close();
    super.dispose();
  }

  refreshNotes() async {
    final value = await noteDatabase.readAll();
    setState(() {
      notes = value;
    });
  }

  goToNoteDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailsView(noteId: id)),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your notes"),
      ),
      body: Center(
        child: notes.isEmpty
            ? const Text(
          'No Notes yet',
          style: TextStyle(color: Colors.white),
        )
            : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return GestureDetector(
                onTap: () => goToNoteDetailsView(id: note.id),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            note.createdTime.toString().split(' ')[0],
                          ),
                          Text(
                            note.title,
                            style:
                            Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
