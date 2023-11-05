import 'package:flutter/material.dart';
//import 'package:notekeep/extensions/buildcontext/loc.dart';
import 'package:notekeep/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "An error occured",
    //title: context.loc.generic_error_prompt,
    content: text,
    optionsBuilder: () => {
      'OK': null
      //context.loc.ok: null,
    },
  );
}
