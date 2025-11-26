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
            /* --------------- page view --------------- */
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: 4,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _pageContent(i),
              ),
            ),

            /* --------------- dots --------------- */
            _Dots(total: 4, index: _page),

            /* --------------- CTA --------------- */
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AppSubmitButton(
                        title: _page == 3 ? 'Get Started' : 'Next',
                        height: 52, // fixed height
                        textColor: AppColors.black,
                        onTap: _next,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _skip,
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(color: Colors.white70),
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

Widget _pageContent(int i) {
  return LayoutBuilder(
    builder: (_, constraints) {
      return Column(
        children: [
          // TOP IMAGE SECTION (exact like your screenshot)
          SizedBox(
            height: constraints.maxHeight * 0.63,
            width: double.infinity,
            child: Image.asset(
              _images[i],
              fit: BoxFit.cover,    // FULL WIDTH, CROPPED EXACTLY LIKE DESIGN
              alignment: Alignment.topCenter,
            ),
          ),

          // SPACING SAME LIKE DESIGN (~40px gap)
          const SizedBox(height: 90),

          // TEXT SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                AppText(
                  _titles[i],
                  textStyle: 'hb',
                  fontSize: 24,
                  color: AppColors.white,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                AppText(
                  _bodies[i],
                  textStyle: 'jb',
                  fontSize: 11,
                  color: AppColors.white,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

}

/* -------------------- dots indicator -------------------- */
class _Dots extends StatelessWidget {
  final int total;
  final int index;
  const _Dots({required this.total, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (i) => AnimatedContainer(
          duration: 300.ms,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: index == i ? 24 : 6,
          decoration: BoxDecoration(
            color: index == i ? AppColors.greenVelvet : AppColors.white,
            borderRadius: BorderRadius.circular(6),
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
