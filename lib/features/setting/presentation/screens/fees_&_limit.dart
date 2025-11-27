import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class FeesAndLimitScreen extends StatelessWidget {
  const FeesAndLimitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: "Fee And Limits", implyLeading: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              // Header Section
              AppText(
                'YOUR CARD, YOUR RULES',
                fontSize: 11,
                color: Colors.grey.shade500,
                textStyle: 'jb',
                w: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppText(
                'Unleash Total Control',
                fontSize: 32,
                color: Theme.of(context).colorScheme.onSurface,
                textStyle: 'hb',
                w: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppText(
                  'Our Visa and MasterCard offerings deliver unmatched utility, powered by the regulated Appollon Digitals ecosystem. Choose the card that fits your life.',
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  textStyle: 'jb',
                  w: FontWeight.w400,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 48),
              // Card Options
              CardOptionWidget(
                cardType: CardType.physical,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              CardOptionWidget(
                cardType: CardType.virtual,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CardType { physical, virtual }

class CardOptionWidget extends StatelessWidget {
  final CardType cardType;
  final bool isDarkMode;

  const CardOptionWidget({
    Key? key,
    required this.cardType,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPhysical = cardType == CardType.physical;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Card Image
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildCardImage(),
              ),
              // Logo badge in top right
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? Colors.black : Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Title and Price
          AppText(
            isPhysical ? 'Physical USD Card' : 'Virtual VFX Tokenized Card',
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
            textStyle: 'hb',
            w: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AppText(
            isPhysical
                ? '\$299.99 (KYC Required)'
                : '\$99.99 (No KYC Required)',
            fontSize: 13,
            color: Colors.grey.shade500,
            textStyle: 'jb',
            w: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Features List
          ...(_getFeatures(
            isPhysical,
          ).map((feature) => _buildFeatureItem(feature, isDarkMode, context))),
          const SizedBox(height: 24),
          // Get Started Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0EA5E9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    'Get Started',
                    fontSize: 15,
                    color: Colors.white,
                    textStyle: 'hb',
                    w: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF), Color(0xFF3B82F6)],
        ),
      ),
      child: Stack(
        children: [
          // Circuit pattern
          Positioned.fill(child: CustomPaint(painter: CircuitPatternPainter())),
          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // EMV Chip with contactless
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 4,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB8941F),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 18,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB8941F),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.contactless,
                          color: Colors.white70,
                          size: 32,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Mastercard logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB001B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-12, 0),
                      child: Container(
                        width: 36,
                        height: 36,
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

  Widget _buildFeatureItem(
    String feature,
    bool isDarkMode,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFE8E8E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              feature,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              textStyle: 'jb',
              w: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getFeatures(bool isPhysical) {
    if (isPhysical) {
      return [
        'KYC Requirement',
        'ATM Access',
        'Global POS Use',
        'Built for daily spend',
      ];
    } else {
      return [
        'No KYC Required',
        'Instant Issuance',
        'Optimized for E-commerce',
        'Unlimited Loads',
      ];
    }
  }
}

class CircuitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw circuit pattern
    final circuitPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    // Top circuit line
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.45, size.height * 0.35);
    path.lineTo(size.width * 0.6, size.height * 0.35);

    // Middle circuit line
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width * 0.55, size.height * 0.45);
    path.lineTo(size.width * 0.75, size.height * 0.45);

    // Bottom circuit line
    path.moveTo(size.width * 0.15, size.height * 0.65);
    path.lineTo(size.width * 0.35, size.height * 0.65);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.65, size.height * 0.6);

    canvas.drawPath(path, circuitPaint);

    // Draw circles at connection points
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.3),
      3,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      3,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.65),
      3,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// AppText Widget (matching your code)
class AppText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? w;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String textStyle;

  const AppText(
    this.data, {
    Key? key,
    this.style,
    this.fontSize,
    this.w,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textStyle = 'jb',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle effective = textStyle == 'hb'
        ? TextStyle(
            fontFamily: 'HubotSans',
            fontSize: fontSize ?? 16,
            fontWeight: w ?? FontWeight.w600,
            color: color,
            height: 1.3,
          )
        : TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: fontSize ?? 14,
            fontWeight: w ?? FontWeight.w400,
            color: color,
            height: 1.5,
          );

    effective = effective.merge(style ?? const TextStyle());

    return Text(
      data,
      style: effective,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
