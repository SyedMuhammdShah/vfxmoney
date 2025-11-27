import 'package:flutter/material.dart';

class WithdrawOptionWidget extends StatelessWidget {
  final VoidCallback onTap;
  const WithdrawOptionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.money_off, color: Theme.of(context).primaryColor),
      title: const Text("Withdraw"),
      onTap: onTap,
    );
  }
}
