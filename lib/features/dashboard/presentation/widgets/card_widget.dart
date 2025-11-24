import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

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
                ),
                _buildActionButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Unload',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
                ),
                _buildActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transaction',
                  color: Theme.of(context).colorScheme.secondary,
                  isActive: false,
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
  }) {
    return Column(
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

class FlippableCard extends StatefulWidget {
  final CardData cardData;

  const FlippableCard({Key? key, required this.cardData}) : super(key: key);

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle < math.pi / 2
                ? _buildFrontCard()
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Slightly smaller radius
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5A8B6F), Color(0xFF3D6B54), Color(0xFF2D5441)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: CardPatternPainter())),
          Padding(
            padding: const EdgeInsets.all(18), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row - Made more compact
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40, // Reduced from 50
                          height: 30, // Reduced from 38
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 3, // Reduced
                                margin: const EdgeInsets.only(
                                  top: 6,
                                ), // Reduced
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB8941F),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 16, // Reduced from 20
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5, // Reduced
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB8941F),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8), // Reduced
                        const Icon(
                          Icons.contactless,
                          color: Colors.white70,
                          size: 22, // Reduced from 28
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CAF50),
                          size: 16, // Reduced from 20
                        ),
                        SizedBox(width: 6), // Reduced
                        Text(
                          'VORTEX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16, // Reduced from 20
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2, // Reduced
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.trending_up,
                  color: Color(0xFF4CAF50),
                  size: 60, // Reduced from 80
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 28, // Reduced from 36
                      height: 28, // Reduced from 36
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB001B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-10, 0), // Reduced offset
                      child: Container(
                        width: 28, // Reduced from 36
                        height: 28, // Reduced from 36
                        decoration: const BoxDecoration(
                          color: Color(0xFFF79E1B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2), // Reduced
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'mastercard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Reduced from 14
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Reduced from 20
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D6B54), Color(0xFF2D5441), Color(0xFF1E3A2C)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20), // Reduced from 30
          Container(height: 40, color: Colors.black), // Reduced from 50
          const SizedBox(height: 15), // Reduced from 20
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18), // Reduced
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32, // Reduced from 40
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ), // Reduced
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'CVV: 123',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 11, // Reduced
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Reduced from 20
                Text(
                  widget.cardData.cardNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Reduced from 18
                    letterSpacing: 1.5, // Reduced
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Holder',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9, // Reduced
                          ),
                        ),
                        const SizedBox(height: 3), // Reduced
                        Text(
                          widget.cardData.holderName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Reduced from 14
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expires',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9, // Reduced
                          ),
                        ),
                        const SizedBox(height: 3), // Reduced
                        Text(
                          widget.cardData.expiryDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Reduced from 14
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    final chartPaint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(40, size.height * 0.6); // Adjusted for smaller card
    path.lineTo(80, size.height * 0.4);
    path.lineTo(120, size.height * 0.5);
    path.lineTo(160, size.height * 0.3);
    path.lineTo(200, size.height * 0.45);
    path.lineTo(240, size.height * 0.25);

    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
