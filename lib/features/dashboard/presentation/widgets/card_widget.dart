import 'package:flutter/material.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/flip_card_widget.dart';
import 'package:vfxmoney/shared/popUp/create_card_popup.dart';
import 'package:vfxmoney/shared/popUp/load_money_popup.dart';
import 'package:vfxmoney/shared/popUp/unload_money_popup.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class VortexCardWalletWidget extends StatefulWidget {
  /// 🔥 Cards coming from SERVER
  final List<CardHolderEntity> cards;

  const VortexCardWalletWidget({
    Key? key,
    required this.cards,
  }) : super(key: key);

  static const double cardHeight = 220;

  @override
  State<VortexCardWalletWidget> createState() =>
      _VortexCardWalletWidgetState();
}

class _VortexCardWalletWidgetState extends State<VortexCardWalletWidget> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);

    _pageController.addListener(() {
      final index = _pageController.page?.round() ?? 0;
      if (index != _currentPage) {
        setState(() => _currentPage = index);
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
    /// 🛑 Empty state
    if (widget.cards.isEmpty) {
      return const Center(child: Text('No cards available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          /// 🔥 CARD SLIDER
          SizedBox(
            height: VortexCardWalletWidget.cardHeight,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FlippableCard(
                    cardData: widget.cards[index],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// 🔸 PAGE INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.cards.length,
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

          /// 🔥 AVAILABLE BALANCE (AUTO CHANGES)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppText(
                          'Available Balance',
                          fontSize: 11,
                          color:
                              Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.visibility_off_outlined,
                          color:
                              Theme.of(context).colorScheme.secondary,
                          size: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(
                          'View More',
                          fontSize: 9,
                          color:
                              Theme.of(context).colorScheme.secondary,
                          textStyle: 'jb',
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// 🔥 BALANCE OF CURRENT CARD
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    widget.cards[_currentPage].balance,
                    fontSize: 18,
                    color:
                        Theme.of(context).colorScheme.onSurface,
                    textStyle: 'hb',
                    w: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// 🔥 ACTION BUTTONS (UNCHANGED)
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
                  color:
                      Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () => UnloadMoneyPopup.show(context),
                ),
                _buildActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transaction',
                  color:
                      Theme.of(context).colorScheme.secondary,
                  isActive: false,
                  onTap: () => CreateCardPopup.show(context),
                ),
                _buildActionButton(
                  icon: Icons.lock_outline,
                  label: 'Hold',
                  color:
                      Theme.of(context).colorScheme.secondary,
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
              color:
                  isActive ? color : Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            label,
            fontSize: 10,
            color:
                isActive ? color : Theme.of(context).colorScheme.secondary,
            textStyle: 'jb',
          ),
        ],
      ),
    );
  }
}
