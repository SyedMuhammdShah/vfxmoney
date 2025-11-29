import 'package:flutter/material.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/flip_card_widget.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';
import 'package:vfxmoney/shared/popUp/create_card_popup.dart';
import 'package:vfxmoney/shared/popUp/load_money_popup.dart';
import 'package:vfxmoney/shared/popUp/unload_money_popup.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';

class VortexCardWalletWidget extends StatefulWidget {
  const VortexCardWalletWidget({Key? key}) : super(key: key);

  /// 🔥 Global consistent card height across all screens
  static const double cardHeight = 220; // Increased from 180

  @override
  State<VortexCardWalletWidget> createState() => _VortexCardWalletWidgetState();
}

class _VortexCardWalletWidgetState extends State<VortexCardWalletWidget> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  final List<CardData> cards = [
    CardData(
      balance: '\$9,858.75',
      cardNumber: '**** **** **** 8472',
      holderName: 'JOHN SMITH',
      expiryDate: '12/25',
    ),
    CardData(
      balance: '\$5,234.50',
      cardNumber: '**** **** **** 3291',
      holderName: 'JANE DOE',
      expiryDate: '09/26',
    ),
    CardData(
      balance: '\$12,500.00',
      cardNumber: '**** **** **** 7834',
      holderName: 'MIKE JOHNSON',
      expiryDate: '03/27',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      if (_currentPage != newIndex) {
        setState(() => _currentPage = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: VortexCardWalletWidget.cardHeight,
            width: double.infinity,
            child: PageView.builder(
              controller: PageController(viewportFraction: 1.0), // FIX HERE
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FlippableCard(cardData: cards[index]),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 🔸 Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              cards.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // 🔥 Balance Card (Reusable everywhere, consistent UI)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppText(
                          'Available Balance',
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(
                          'View More',
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    cards[_currentPage].balance,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                    textStyle: 'hb',
                    w: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 🔥 Action Buttons (consistent across screens)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.add_card_outlined,
                  label: 'Load',
                  color: Theme.of(context).primaryColor,
                  isActive: true,
                  onTap: () => LoadMoneyPopup.show(context),
                ),
                _buildActionButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Unload',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () => UnloadMoneyPopup.show(context),
                ),
                _buildActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transaction',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () => CreateCardPopup.show(context),
                ),
                _buildActionButton(
                  icon: Icons.lock_outline,
                  label: 'Hold',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive
                  ? color.withOpacity(0.20)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: isActive ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? color : Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            label,
            fontSize: 10,
            color: isActive ? color : Theme.of(context).colorScheme.secondary,
            textStyle: 'jb',
          ),
        ],
      ),
    );
  }
}

// ------------------ Supporting Classes -------------------

class CardData {
  final String balance;
  final String cardNumber;
  final String holderName;
  final String expiryDate;

  CardData({
    required this.balance,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
  });
}
