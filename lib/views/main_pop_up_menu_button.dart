import 'package:demo/dialogs/delete_account_dialog.dart';
import 'package:demo/dialogs/logout_dialog.dart';
import 'package:demo/type_definitions.dart';
import 'package:flutter/material.dart';

enum MenuAction { logout, delete }

class MainPopupMenuWidget extends StatelessWidget {
  const MainPopupMenuWidget({
    Key? key,
    required this.logoutCallBack,
    required this.deleteAccountCallBack,
  }) : super(key: key);

  final LogoutCallBack logoutCallBack;
  final DeleteAccountCallBack deleteAccountCallBack;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context: context);
            if (shouldLogout) logoutCallBack();
            break;
          case MenuAction.delete:
            final shouldDelete = await showDeleteAccountDialog(context);
            if (shouldDelete) deleteAccountCallBack();
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<MenuAction>(
          value: MenuAction.logout,
          child: Text('Logout'),
        ),
        const PopupMenuItem<MenuAction>(
          value: MenuAction.delete,
          child: Text('Delete Account'),
        ),
      ],
    );
  }
}
