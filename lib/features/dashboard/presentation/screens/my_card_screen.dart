import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

// This is the widget you can use in your app
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
          separatorBuilder: (context, index) => const SizedBox(height: 16),
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
    // Theme-aware colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF5F5F5);

    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Card Image
          Container(
            width: 100,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildCardFront(),
            ),
          ),
          const SizedBox(width: 16),
          // Balance Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 6),
                Icon(
                  card.showBalance
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: secondaryTextColor,
                  size: 1,
                ),

                const SizedBox(height: 8),
                Text(
                  'Available Balance',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  card.balance,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // View Card Button
          GestureDetector(
            onTap: () {
              // Handle view card tap
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'View Card',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: card.cardType == CardType.green
              ? [
                  const Color(0xFF5A8B6F),
                  const Color(0xFF3D6B54),
                  const Color(0xFF2D5441),
                ]
              : [
                  const Color(0xFF4A6FA5),
                  const Color(0xFF3D5A8C),
                  const Color(0xFF2D4473),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: CustomPaint(painter: MiniCardPatternPainter()),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // EMV Chip
                    Container(
                      width: 20,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 2,
                            margin: const EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8941F),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8941F),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Vortex Logo
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 6,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'VORTEX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Mastercard Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB001B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF79E1B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MiniCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw grid pattern
    for (double i = 0; i < size.width; i += 8) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 8) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw chart lines
    final chartPaint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    path.moveTo(10, size.height * 0.6);
    path.lineTo(20, size.height * 0.4);
    path.lineTo(30, size.height * 0.5);
    path.lineTo(40, size.height * 0.3);
    path.lineTo(50, size.height * 0.45);
    path.lineTo(60, size.height * 0.25);

    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
