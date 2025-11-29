import 'package:flutter/material.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/transaction_list_widget.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Transactions', implyLeading: true),
      body: const TransactionListFullScreen(), // Remove SizedBox and use directly
    );
  }
}