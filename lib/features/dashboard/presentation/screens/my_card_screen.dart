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
          separatorBuilder: (context, index) => const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large Card Image
          _buildCardImage(),

          const SizedBox(height: 20),

          // Balance Section Below Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Balance",
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.showBalance ? card.balance : "•••••••••",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Eye Icon to show/hide balance
              Icon(
                card.showBalance
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 24,
                color: secondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// -------- LARGE CARD IMAGE --------
  Widget _buildCardImage() {
    final String image = card.cardType == CardType.green
        ? "assets/images/card_front.png"
        : "assets/images/card_front.png";

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(image, fit: BoxFit.cover),
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
