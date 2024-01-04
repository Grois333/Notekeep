import 'package:flutter/material.dart';
import 'package:notekeep/extensions/buildcontext/loc.dart';
import 'package:notekeep/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.password_reset,
    //title: 'Password reset',
    content: context.loc.password_reset_dialog_prompt,
    //content: 'We have sent you a password reset link. Please check your email for more information.',
    optionsBuilder: () => {
      context.loc.ok: null,
      //'OK': null,
    },
  );
}
