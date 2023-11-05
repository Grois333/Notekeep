import 'package:flutter/material.dart';
//import 'package:notekeep/extensions/buildcontext/loc.dart';
import 'package:notekeep/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log Out",
    //title: context.loc.logout_button,
    content: "Are you sure you want to logout?",
    //content: context.loc.logout_dialog_prompt,
    optionsBuilder: () => {
      "Cancel": false,
      //context.loc.cancel: false,
      "Log out": true,
      //context.loc.logout_button: true,
    },
  )
  .then(
    (value) => value ?? false,
  );
}
