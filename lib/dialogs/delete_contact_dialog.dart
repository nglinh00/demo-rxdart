import 'package:demo/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteContactDialog(BuildContext context) => showGenericDialog(
      context: context,
      title: 'Delete Contact',
      content: 'Are you sure you want to delete your Contact?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete Contact': true,
      },
    ).then((value) => value ?? false);
