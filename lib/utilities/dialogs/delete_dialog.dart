import 'package:flutter/material.dart';
//import 'package:notekeep/extensions/buildcontext/loc.dart';
import 'package:notekeep/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    //title: context.loc.delete,
    content: "Are you sure you want to delete this item?",
    //content: context.loc.delete_note_prompt,
    optionsBuilder: () => {
       "Cancel": false,
      //context.loc.cancel: false,
      "Yes": true,
      //context.loc.yes: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
