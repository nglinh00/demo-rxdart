import 'package:demo/models/contact.dart';
import 'package:flutter/material.dart';

typedef LogoutCallBack = VoidCallback;
typedef GoBackCallBack = VoidCallback;
typedef DeleteAccountCallBack = VoidCallback;

typedef LoginFunction = void Function({required String email, required String password});
typedef RegisterFunction = void Function({required String email, required String password});

typedef CreateContactCallBack = void Function(
    {required String firstName, required String lastName, required String phoneNumber});

typedef DeleteContactCallBack = void Function(Contact contact);
