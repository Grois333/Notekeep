import 'package:flutter/material.dart';
//import 'package:notekeep/services/cloud/cloud_note.dart';
import 'package:notekeep/services/crud/notes_service.dart';
import 'package:notekeep/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNote note);
//typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {

  final List<DatabaseNote> notes;

  //final Iterable<CloudNote> notes;

  final DeleteNoteCallBack onDeleteNote;
  //final NoteCallback onDeleteNote;

  //final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    //required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          // onTap: () {
          //   onTap(note);
          // },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
