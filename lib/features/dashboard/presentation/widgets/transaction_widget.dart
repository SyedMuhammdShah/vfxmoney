import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dividerColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : Colors.grey.shade300;
    final Color iconBorderColor = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /* ------------ header ------------ */
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'Transaction',
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    textStyle: 'hb',
                    w: FontWeight.w700,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: AppText(
                      'See All',
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface,
                      textStyle: 'jb',
                      w: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            /* ------------ list ------------ */
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TransactionTable(
                  transactions: _dummyTransactions,
                  dividerColor: dividerColor,
                  iconBorderColor: iconBorderColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  TABLE WIDGET  (pixel-perfect)
 * ---------------------------------------------------------- */
class _TransactionTable extends StatelessWidget {
  final List<Transaction> transactions;
  final Color dividerColor;
  final Color iconBorderColor;

  const _TransactionTable({
    required this.transactions,
    required this.dividerColor,
    required this.iconBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => _Divider(color: dividerColor),
      itemBuilder: (_, i) =>
          _TableRowItem(tx: transactions[i], iconBorderColor: iconBorderColor),
    );
  }
}

class _TableRowItem extends StatelessWidget {
  final Transaction tx;
  final Color iconBorderColor;

  const _TableRowItem({required this.tx, required this.iconBorderColor});

  @override
  Widget build(BuildContext context) {
    final Color iconBackgroundColor = Theme.of(context).colorScheme.surface;
    final Color iconColor = Theme.of(context).colorScheme.onSurface;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* 1️⃣  icon column  (fixed width) */
          SizedBox(
            width: 40,
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: iconBorderColor, width: 2),
                ),
                child: Icon(
                  tx.type == TransactionType.load
                      ? Icons.add_card_rounded
                      : Icons.account_balance_wallet_rounded,
                  color: iconColor,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          /* 2️⃣  centre column  (title + date)  (expands) */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  tx.title,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  textStyle: 'hb',
                  w: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                AppText(
                  tx.date,
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.secondary,
                  textStyle: 'jb',
                  w: FontWeight.w400,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /* 3️⃣  right column  (status + amount)  (fixed width) */
          SizedBox(
            width: 80, // enough for "Rejected" & "+\$100.00"
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  tx.status.label,
                  fontSize: 12,
                  color: tx.status.color,
                  textStyle: 'jb',
                  w: FontWeight.w600,
                ),
                const SizedBox(height: 5),
                AppText(
                  tx.amount,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  textStyle: 'hb',
                  w: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  DIVIDER  (indented 80 px)
 * ---------------------------------------------------------- */
class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 80),
      color: color,
    );
  }
}

/* ----------------------------------------------------------
 *  MODELS
 * ---------------------------------------------------------- */
enum TransactionType { load, unload }

enum TransactionStatus {
  approved(Color(0xFF4CAF50)),
  rejected(Color(0xFFE53935)),
  pending(Color(0xFFFFA726));

  const TransactionStatus(this.color);
  final Color color;
  String get label => name[0].toUpperCase() + name.substring(1);
}

class Transaction {
  final String title;
  final String date;
  final String amount;
  final TransactionStatus status;
  final TransactionType type;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
  });
}

/* ----------------------------------------------------------
 *  DUMMY DATA  (same as your list)
 * ---------------------------------------------------------- */
final List<Transaction> _dummyTransactions = [
  Transaction(
    title: 'Load Money To Beetoo',
    date: '8 Jan 2025 2:53 PM',
    amount: '+\$100.00',
    status: TransactionStatus.rejected,
    type: TransactionType.load,
  ),
  Transaction(
    title: 'Load Money To Smith',
    date: '8 Jan 2025 2:53 PM',
    amount: '+\$100.00',
    status: TransactionStatus.approved,
    type: TransactionType.load,
  ),
  Transaction(
    title: 'Unload Money To Smith',
    date: '8 Jan 2025 2:53 PM',
    amount: '+\$100.00',
    status: TransactionStatus.pending,
    type: TransactionType.unload,
  ),
  Transaction(
    title: 'Unload Money To Beetoo',
    date: '8 Jan 2025 2:53 PM',
    amount: '+\$100.00',
    status: TransactionStatus.approved,
    type: TransactionType.unload,
  ),
  Transaction(
    title: 'Unload Money To Beetoo',
    date: '8 Jan 2025 2:53 PM',
    amount: '+\$100.00',
    status: TransactionStatus.approved,
    type: TransactionType.unload,
  ),
];
