import 'package:demo/dialogs/delete_contact_dialog.dart';
import 'package:demo/models/contact.dart';
import 'package:demo/type_definitions.dart';
import 'package:demo/views/main_pop_up_menu_button.dart';
import 'package:flutter/material.dart';

class ContactListView extends StatelessWidget {
  const ContactListView({
    Key? key,
    required this.logoutCallBack,
    required this.deleteContactCallBack,
    required this.deleteAccountCallBack,
    required this.createNewContactCallBack,
    required this.contacts,
  }) : super(key: key);

  final LogoutCallBack logoutCallBack;
  final DeleteContactCallBack deleteContactCallBack;
  final DeleteAccountCallBack deleteAccountCallBack;
  final VoidCallback createNewContactCallBack;
  final Stream<Iterable<Contact>> contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        actions: [
          MainPopupMenuWidget(
            logoutCallBack: logoutCallBack,
            deleteAccountCallBack: deleteAccountCallBack,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContactCallBack,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final contacts = snapshot.requireData;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, i) => ContactListTile(
                  contact: contacts.elementAt(i),
                  deleteContactCallBack: deleteContactCallBack,
                ),
              );
          }
        },
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    Key? key,
    required this.contact,
    required this.deleteContactCallBack,
  }) : super(key: key);

  final Contact contact;
  final DeleteContactCallBack deleteContactCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
        title: Text(contact.fullName),
        trailing: IconButton(
          onPressed: () async {
            final shouldDelete = await showDeleteContactDialog(context);
            if (shouldDelete) deleteContactCallBack(contact);
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
