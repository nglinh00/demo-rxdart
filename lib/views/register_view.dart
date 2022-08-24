import 'package:demo/helpers/if_debugging.dart';
import 'package:demo/type_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterView extends HookWidget {
  const RegisterView({
    Key? key,
    required this.registerFunction,
    required this.goToLoginView,
  }) : super(key: key);

  final RegisterFunction registerFunction;
  final VoidCallback goToLoginView;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'demo@gmail.com'.ifDebugging);
    final passwordController = useTextEditingController(text: '123456'.ifDebugging);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            obscureText: true,
          ),
          TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                registerFunction(email: email, password: password);
              },
              child: const Text('Register')),
          TextButton(
            onPressed: goToLoginView,
            child: const Text('Login here'),
          ),
        ]),
      ),
    );
  }
}
