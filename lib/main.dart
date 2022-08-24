import 'dart:async';

import 'package:demo/blocs/app_bloc.dart';
import 'package:demo/blocs/auth_bloc/auth_error.dart';
import 'package:demo/blocs/views_bloc/current_view.dart';
import 'package:demo/dialogs/auth_error_dialog.dart';
import 'package:demo/loading/loading_screen.dart';
import 'package:demo/views/contact_list_view.dart';
import 'package:demo/views/login_view.dart';
import 'package:demo/views/new_contact_view.dart';
import 'package:demo/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorSub;
  StreamSubscription<bool?>? _isLoadingSub;

  @override
  void initState() {
    appBloc = AppBloc();
    super.initState();
  }

  @override
  void dispose() {
    _authErrorSub?.cancel();
    _isLoadingSub?.cancel();
    super.dispose();
  }

  void handleAuthError(BuildContext context) async {
    await _authErrorSub?.cancel();
    _authErrorSub = appBloc.authError.listen((event) {
      final AuthError? authError = event;
      if (authError == null) return;
      showAuthError(context: context, authError: authError);
    });
  }

  void setUpLoadingScreen(BuildContext context) async {
    await _isLoadingSub?.cancel();
    _isLoadingSub = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        LoadingScreen.instance().show(context, 'Loading...');
      } else {
        LoadingScreen.instance().hide();
      }
    });
  }

  Widget getHomePage() => StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  loginFunction: appBloc.login,
                  goToRegisterView: appBloc.goToRegisterView,
                );
              case CurrentView.register:
                return RegisterView(
                  registerFunction: appBloc.register,
                  goToLoginView: appBloc.goToLoginView,
                );
              case CurrentView.contactList:
                return ContactListView(
                  logoutCallBack: appBloc.logout,
                  deleteContactCallBack: appBloc.deleteContact,
                  deleteAccountCallBack: appBloc.deleteAccount,
                  createNewContactCallBack: appBloc.goToCreateContactView,
                  contacts: appBloc.contacts,
                );

              case CurrentView.createContact:
                return NewContactView(
                  createContactCallBack: appBloc.createContact,
                  goBackCallBack: appBloc.goToContactListView,
                );
            }
          default:
            return Container();
        }
      });

  @override
  Widget build(BuildContext context) {
    handleAuthError(context);
    setUpLoadingScreen(context);
    return getHomePage();
  }
}
