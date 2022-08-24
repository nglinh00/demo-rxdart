import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/contact.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() => switchMap(
        (optional) async* {
          if (optional != null) {
            yield optional;
          }
        },
      );
}

@immutable
class ContactsBloc {
  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription;

  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;

  void dispose() {
    userId.close();
  }

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    final userId = BehaviorSubject<String?>();

    final Stream<Iterable<Contact>> contacts = userId.switchMap<_Snapshots>((userId) {
      if (userId == null) {
        return const Stream<_Snapshots>.empty();
      } else {
        return backend.collection(userId).snapshots();
      }
    }).map<Iterable<Contact>>((snapshots) sync* {
      for (final doc in snapshots.docs) {
        yield Contact.fromJson(doc.data(), id: doc.id);
      }
    });

    final createContact = BehaviorSubject<Contact>();

    final createContactSubscription = createContact
        .switchMap(
          (Contact contactToCreate) => userId.take(1).unwrap().asyncMap(
                (userId) => backend.collection(userId).add(contactToCreate.data),
              ),
        )
        .listen((event) {});

    final deleteContact = BehaviorSubject<Contact>();

    final deleteContactSubscription = deleteContact
        .switchMap(
          (Contact contactToDelete) => userId.take(1).unwrap().asyncMap(
                (userId) => backend.collection(userId).doc(contactToDelete.id).delete(),
              ),
        )
        .listen((event) {});

    return ContactsBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
    );
  }
}
