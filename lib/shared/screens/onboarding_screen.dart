import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  /* >>> replace these three images with your real assets <<< */
  final List<String> _images = [
    AppIcons.onboardImage,
    AppIcons.onboardImage,
    AppIcons.onboardImage,
    AppIcons.onboardImage,
  ];

  final List<String> _titles = [
    'Welcome To Vortex Card',
    'Virtual Crypto Card Anytime, Anywhere',
    'Physical Crypto Card One Card For All',
    'Pay, Send, Transfer with Vortex',
  ];

  final List<String> _bodies = [
    'Loren Ipsun is simply dummy text of the printing and typesetting industry.',
    'Loren Ipsun is simply dummy text of the printing and typesetting industry.',
    'Loren Ipsun is simply dummy text of the printing and typesetting industry.',
    'Loren Ipsun is simply dummy text of the printing and typesetting industry.',
  ];

  void _next() {
    if (_page < 3) {
      _ctrl.nextPage(duration: 300.ms, curve: Curves.ease);
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  void _finish() {
    context.pushNamed(Routes.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 700;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.black, AppColors.black],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: 4,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) =>
                    _pageContent(i, screenSize, isSmallScreen),
              ),
            ),

            /* --------------- dots --------------- */
            _Dots(total: 4, index: _page),

            /* --------------- CTA --------------- */
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  isSmallScreen ? 8 : 12,
                  24,
                  isSmallScreen ? 16 : 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 48 : 52,
                      child: AppSubmitButton(
                        title: _page == 3 ? 'Get Started' : 'Next',
                        height: isSmallScreen ? 48 : 52,
                        textColor: AppColors.black,
                        onTap: _next,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    TextButton(
                      onPressed: _skip,
                      child: AppText(
                        'Skip for now',
                        fontSize: 14,
                        color: Colors.white70,
                        textStyle: 'jb',
                        w: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageContent(int i, Size screenSize, bool isSmallScreen) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenSize.height),
        child: Column(
          children: [
            // TOP IMAGE SECTION - Responsive
            Container(
              height: isSmallScreen
                  ? screenSize.height * 0.55
                  : screenSize.height * 0.63,
              width: double.infinity,
              child: _buildResponsiveImage(_images[i], screenSize),
            ),

            // SPACING - Responsive
            SizedBox(height: isSmallScreen ? 20 : 50),

            // TEXT SECTION - Responsive
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width > 400 ? 32 : 24,
              ),
              child: Column(
                children: [
                  AppText(
                    _titles[i],
                    textStyle: 'hb',
                    fontSize: _getResponsiveFontSize(screenSize, 20, 24, 28),
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                    w: FontWeight.w700,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  AppText(
                    _bodies[i],
                    textStyle: 'jb',
                    fontSize: _getResponsiveFontSize(screenSize, 10, 11, 12),
                    color: AppColors.white.withOpacity(0.8),
                    textAlign: TextAlign.center,
                    w: FontWeight.w400,
                  ),
                ],
              ),
            ),

            // Add flexible space to push content up on smaller screens
            if (isSmallScreen) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveImage(String imagePath, Size screenSize) {
    final double aspectRatio = screenSize.width / screenSize.height;

    // Different fit strategies based on screen aspect ratio
    BoxFit fit = BoxFit.cover;
    Alignment alignment = Alignment.topCenter;

    if (aspectRatio > 0.6) {
      // Wider screens - use contain to avoid excessive cropping
      fit = BoxFit.fill;
      alignment = Alignment.center;
    }

    return Image.asset(
      imagePath,
      fit: fit,
      alignment: alignment,
      // Add error builder for better image handling
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.greyColor,
          child: const Icon(
            Icons.credit_card,
            color: AppColors.white,
            size: 60,
          ),
        );
      },
      // Add loading builder for better UX
      // loadingBuilder: (context, child, loadingProgress) {
      //   if (loadingProgress == null) return child;
      //   return Container(
      //     color: AppColors.greyColor,
      //     child: Center(
      //       child: CircularProgressIndicator(
      //         value: loadingProgress.expectedTotalBytes != null
      //             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
      //             : null,
      //         color: AppColors.greenVelvet,
      //       ),
      //     ),
      //   );
      // },
    );
  }

  double _getResponsiveFontSize(
    Size screenSize,
    double small,
    double medium,
    double large,
  ) {
    if (screenSize.width < 350) return small;
    if (screenSize.width > 400) return large;
    return medium;
  }
}

/* -------------------- dots indicator -------------------- */
class _Dots extends StatelessWidget {
  final int total;
  final int index;
  const _Dots({required this.total, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 700;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          total,
          (i) => AnimatedContainer(
            duration: 300.ms,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: isSmallScreen ? 5 : 6,
            width: index == i
                ? (isSmallScreen ? 20 : 24)
                : (isSmallScreen ? 5 : 6),
            decoration: BoxDecoration(
              color: index == i
                  ? AppColors.greenVelvet
                  : AppColors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------- helper for quick durations -------------------- */
extension _IntDurations on int {
  Duration get ms => Duration(milliseconds: this);
}
