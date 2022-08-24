import 'package:demo/helpers/if_debugging.dart';
import 'package:demo/type_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewContactView extends HookWidget {
  const NewContactView({
    Key? key,
    required this.createContactCallBack,
    required this.goBackCallBack,
  }) : super(key: key);

  final CreateContactCallBack createContactCallBack;
  final GoBackCallBack goBackCallBack;

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: 'demo first name'.ifDebugging);
    final lastNameController = useTextEditingController(text: 'demo last name'.ifDebugging);
    final phoneNumberController = useTextEditingController(text: '+12345678'.ifDebugging);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: goBackCallBack, icon: const Icon(Icons.close)),
      ),
      body: Column(children: [
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(
            hintText: 'First name',
          ),
          keyboardType: TextInputType.name,
        ),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            hintText: 'Last name',
          ),
          keyboardType: TextInputType.name,
        ),
        TextField(
          controller: phoneNumberController,
          decoration: const InputDecoration(
            hintText: 'Phone number',
          ),
          keyboardType: TextInputType.phone,
        ),
        TextButton(
          onPressed: () {
            final firstName = firstNameController.text;
            final lastName = lastNameController.text;
            final phoneNumber = phoneNumberController.text;
            createContactCallBack(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber);
            goBackCallBack();
          },
          child: const Text('Save contact'),
        ),
      ]),
    );
  }
}
