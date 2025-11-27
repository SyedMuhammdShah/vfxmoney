import 'package:flutter/material.dart';

class DepositOptionWidget extends StatelessWidget {
  final VoidCallback onTap;
  const DepositOptionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_balance_wallet,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text("Deposit"),
      onTap: onTap,
    );
  }
}
