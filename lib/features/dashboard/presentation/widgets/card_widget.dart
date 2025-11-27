import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/create_card_widget.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/flip_card_widget.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';
import 'package:vfxmoney/shared/popUp/create_card_popup.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class VortexCardWalletWidget extends StatefulWidget {
  const VortexCardWalletWidget({Key? key}) : super(key: key);

  @override
  State<VortexCardWalletWidget> createState() => _VortexCardWalletWidgetState();
}

class _VortexCardWalletWidgetState extends State<VortexCardWalletWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
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
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
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
          // Card Carousel - Reduced height from 240 to 180
          SizedBox(
            height: 180, // Reduced from 240
            child: PageView.builder(
              controller: _pageController,
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
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              cards.length,
              (index) => Container(
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
          // Balance Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppText(
                          'Available Balance',
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                          w: FontWeight.w400,
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
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                          w: FontWeight.w400,
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
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    cards[_currentPage].balance,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    textStyle: 'hb',
                    w: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.add_card_outlined,
                  label: 'Load',
                  color: Theme.of(context).primaryColor, // Green Velvet
                  isActive: true,
                  onTap: () {
                    _showLoadMoneyPopup(context);
                  },
                ),
                _buildActionButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Unload',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () {
                    _showUnloadMoneyPopup(context);
                  },
                ),
                _buildActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transaction',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () {
                    CreateCardPopup();
                  },
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
    VoidCallback? onTap, // <-- new param
  }) {
    return InkWell(
      // makes it clickable
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive
                  ? color.withOpacity(0.2)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isActive ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? color : Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            label,
            fontSize: 10,
            color: isActive ? color : Theme.of(context).colorScheme.secondary,
            textStyle: 'jb',
            w: FontWeight.w500,
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

void _showLoadMoneyPopup(BuildContext context) {
  DynamicFormPopup.show(
    context: context,
    title: 'Load Money',
    subtitle: 'Deposit your fund in your Card',
    fields: [
      FormFieldData(
        label: 'Amount',
        labelSuffix: '(USD)',
        hintText: '\$500',
        keyboardType: TextInputType.number,
        prefixText: '\$',
      ),
      FormFieldData(
        label: 'Payment Method',
        hintText: 'Crypto',
        isDropdown: true,
        dropdownItems: ['Crypto', 'Bank Transfer', 'Credit Card'],
      ),
      FormFieldData(
        label: 'Proof of Payment',
        hintText: 'Screen Shoot',
        isFilePicker: true,
        helperText: 'Click here  this link preview image',
        helperActionText: 'Click here',
      ),
    ],
    buttonText: 'Confirm Load Money',
    onSubmit: (values) {
      print('Load Money Values: $values');
    },
  );
}

void _showUnloadMoneyPopup(BuildContext context) {
  DynamicFormPopup.show(
    context: context,
    title: 'Unload Money',
    subtitle: 'Enter the details to unload funds for\nCard **** **** **** 2375',
    fields: [
      FormFieldData(
        label: 'Amount',
        labelSuffix: '(USD)',
        hintText: '\$500',
        keyboardType: TextInputType.number,
        prefixText: '\$',
        isDropdown: true,
      ),
      FormFieldData(
        label: 'Wallet Address',
        labelSuffix: '(USD)',
        hintText: '0Xabc123',
        keyboardType: TextInputType.text,
      ),
      FormFieldData(
        label: 'Blockchain',
        hintText: 'Eg. Ethereum',
        isDropdown: true,
        dropdownItems: ['Ethereum', 'Bitcoin', 'Polygon', 'BSC'],
      ),
    ],
    buttonText: 'Confirm Unload Money',
    onSubmit: (values) {
      print('Unload Money Values: $values');
    },
  );
}
