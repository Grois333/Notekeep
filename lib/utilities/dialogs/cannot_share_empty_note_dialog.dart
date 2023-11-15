import 'package:flutter/material.dart';
//import 'package:notekeep/extensions/buildcontext/loc.dart';
import 'package:notekeep/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    //title: context.loc.sharing,
    title: 'Sharing',
    //content: context.loc.cannot_share_empty_note_prompt,
    content: 'You cannot share an empty note!',
    optionsBuilder: () => {
      'OK': null,
      //context.loc.ok: null,
    },
  );
}
