import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class TransactionListFullScreen extends StatelessWidget {
  const TransactionListFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dividerColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : Colors.grey.shade300;
    final Color iconBorderColor = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.grey.shade300;

    return Column(
      children: [
        /* ------------ Filter Tabs ------------ */
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: _FilterTabs(),
        ),
        /* ------------ list ------------ */
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _TransactionTable(
              transactions: _dummyTransactions,
              dividerColor: dividerColor,
              iconBorderColor: iconBorderColor,
            ),
          ),
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------
 *  FILTER TABS
 * ---------------------------------------------------------- */
class _FilterTabs extends StatefulWidget {
  @override
  State<_FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<_FilterTabs> {
  int _selectedIndex = 0;

  final List<String> _tabs = ['Transaction', 'Card Transaction'];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveBackground = isDarkMode
        ? const Color(0xFF1A1A1A)
        : Colors.grey.shade200;
    final Color inactiveBorder = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.grey.shade400;
    final Color inactiveTextColor = Theme.of(context).colorScheme.onSurface;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final bool isSelected = _selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : inactiveBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(color: inactiveBorder, width: 1),
                ),
                child: AppText(
                  _tabs[index],
                  fontSize: 12,
                  color: isSelected ? Colors.black : inactiveTextColor,
                  textStyle: 'jb',
                  w: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
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
    final Color iconBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color iconColor = Theme.of(context).colorScheme.onSurface;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* 1️⃣  icon column - Reduced size */
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: iconBorderColor, width: 1.5),
            ),
            child: Icon(
              tx.type == TransactionType.load
                  ? Icons.add_card_rounded
                  : Icons.account_balance_wallet_rounded,
              color: iconColor,
              size: 20, // Reduced icon size
            ),
          ),

          const SizedBox(width: 12), // Reduced spacing
          /* 2️⃣  centre column  (title + date) */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  tx.title,
                  fontSize: 14, // Reduced from 16
                  color: textColor,
                  textStyle: 'hb',
                  w: FontWeight.w500,
                ),
                const SizedBox(height: 2), // Reduced spacing
                AppText(
                  tx.date,
                  fontSize: 11, // Reduced from 12
                  color: secondaryTextColor,
                  textStyle: 'jb',
                  w: FontWeight.w400,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12), // Reduced spacing
          /* 3️⃣  right column  (status + amount) */
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                tx.status.label,
                fontSize: 11, // Reduced from 13
                color: tx.status.color,
                textStyle: 'jb',
                w: FontWeight.w600,
              ),
              const SizedBox(height: 2), // Reduced spacing
              AppText(
                tx.amount,
                fontSize: 14, // Reduced from 16
                color: textColor,
                textStyle: 'hb',
                w: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  DIVIDER  (indented 72 px - reduced)
 * ---------------------------------------------------------- */
class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72), // Reduced from 80
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
 *  DUMMY DATA
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
