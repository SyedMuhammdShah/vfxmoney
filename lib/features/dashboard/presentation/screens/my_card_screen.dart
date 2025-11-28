import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<CardModel> cards = [
      CardModel(
        balance: '\$9,858.75',
        cardType: CardType.green,
        showBalance: true,
      ),
      CardModel(
        balance: '\$9,858.75',
        cardType: CardType.green,
        showBalance: false,
      ),
      CardModel(
        balance: '\$19,948.75',
        cardType: CardType.blue,
        showBalance: true,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'My Card', implyLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: cards.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            return CardListItem(card: cards[index], isDarkMode: isDarkMode);
          },
        ),
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  final CardModel card;
  final bool isDarkMode;

  const CardListItem({Key? key, required this.card, required this.isDarkMode})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          _buildCardImage(),

          const SizedBox(width: 16),

          // Balance Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eye Icon to show/hide balance
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    card.showBalance
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: secondaryTextColor,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Available Balance",
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                ),

                const SizedBox(height: 4),

                Text(
                  card.showBalance ? card.balance : "•••••••••",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------- CARD IMAGE --------
  Widget _buildCardImage() {
    final String image = card.cardType == CardType.green
        ? "assets/images/card_front.png"
        : "assets/images/card_front.png";

    return Container(
      width: 120,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }

  /// -------- VIEW CARD BUTTON --------
  Widget _buildViewButton() {
    return GestureDetector(
      onTap: () {
        // Implement view card screen
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "View Card",
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum CardType { green, blue }

class CardModel {
  final String balance;
  final CardType cardType;
  final bool showBalance;

  CardModel({
    required this.balance,
    required this.cardType,
    required this.showBalance,
  });
}
