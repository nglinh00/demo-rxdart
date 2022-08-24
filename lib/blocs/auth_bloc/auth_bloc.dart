import 'package:demo/blocs/auth_bloc/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

@immutable
abstract class AuthStatus {
  const AuthStatus();
}

@immutable
class AuthStatusLoggedOut extends AuthStatus {
  const AuthStatusLoggedOut();
}

@immutable
class AuthStatusLoggedIn extends AuthStatus {
  const AuthStatusLoggedIn();
}

@immutable
abstract class AuthCommand {
  const AuthCommand({required this.email, required this.password});
  final String email;
  final String password;
}

@immutable
class LoginCommand extends AuthCommand {
  const LoginCommand({required super.email, required super.password});
}

@immutable
class RegisterCommand extends AuthCommand {
  const RegisterCommand({required super.email, required super.password});
}

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(bool isLoading, {required Sink<bool> onSink}) => doOnEach(
        (_) {
          onSink.add(isLoading);
        },
      );
}

@immutable
class AuthBloc {
  const AuthBloc._({
    required this.authStatus,
    required this.authError,
    required this.userId,
    required this.isLoading,
    required this.login,
    required this.register,
    required this.logout,
  });

  final Stream<AuthStatus> authStatus;
  final Stream<AuthError?> authError;
  final Stream<String?> userId;
  final Stream<bool> isLoading;

  final Sink<LoginCommand> login;
  final Sink<RegisterCommand> register;
  final Sink<void> logout;

  void dispose() {
    login.close();
    register.close();
    logout.close();
  }

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();

    final Stream<AuthStatus> authStatusChanged = FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      } else {
        return const AuthStatusLoggedOut();
      }
    });

    final Stream<String?> userId = FirebaseAuth.instance
        .authStateChanges()
        .map((user) => user?.uid)
        .startWith(FirebaseAuth.instance.currentUser?.uid);

    final login = BehaviorSubject<LoginCommand>();

    final Stream<AuthError?> loginError = login.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>(
      (loginCommand) async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: loginCommand.email,
            password: loginCommand.password,
          );
          return null;
        } on FirebaseAuthException catch (e) {
          return AuthError.from(e);
        } catch (_) {
          return const AuthErrorUnknown();
        }
      },
    ).setLoadingTo(false, onSink: isLoading);

    final register = BehaviorSubject<RegisterCommand>();

    final Stream<AuthError?> registerError = register.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>(
      (registerCommand) async {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: registerCommand.email,
            password: registerCommand.password,
          );
          return null;
        } on FirebaseAuthException catch (e) {
          return AuthError.from(e);
        } catch (_) {
          return const AuthErrorUnknown();
        }
      },
    ).setLoadingTo(false, onSink: isLoading);

    final logout = BehaviorSubject<void>();

    final Stream<AuthError?> logoutError = logout.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>(
      (_) async {
        try {
          await FirebaseAuth.instance.signOut();
          return null;
        } on FirebaseAuthException catch (e) {
          return AuthError.from(e);
        } catch (_) {
          return const AuthErrorUnknown();
        }
      },
    ).setLoadingTo(false, onSink: isLoading);

    final Stream<AuthError?> authError = Rx.merge([
      loginError,
      registerError,
      logoutError,
    ]);

    return AuthBloc._(
      authStatus: authStatusChanged,
      authError: authError,
      userId: userId,
      isLoading: isLoading,
      login: login,
      register: register,
      logout: logout,
    );
  }
}
