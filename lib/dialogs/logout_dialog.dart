import 'package:demo/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog({required BuildContext context}) => showGenericDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      optionsBuilder: () => {
        'Cancel': false,
        'Log out': true,
      },
    ).then((value) => value ?? false);
