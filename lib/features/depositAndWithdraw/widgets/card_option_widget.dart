import 'package:flutter/material.dart';

class CreateCardOptionWidget extends StatelessWidget {
  final VoidCallback onTap;
  const CreateCardOptionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
      title: const Text("Create Card"),
      onTap: onTap,
    );
  }
}
