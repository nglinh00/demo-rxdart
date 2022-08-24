import 'package:demo/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) => showGenericDialog(
      context: context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete your account?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete Account': true,
      },
    ).then((value) => value ?? false);
