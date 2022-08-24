import 'package:demo/blocs/auth_bloc/auth_error.dart';
import 'package:demo/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAuthError({
  required BuildContext context,
  required AuthError authError,
}) =>
    showGenericDialog(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {'OK': true},
    );
