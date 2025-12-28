import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/flip_card_widget.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/popUp/create_card_popup.dart';
import 'package:vfxmoney/shared/popUp/load_money_popup.dart';
import 'package:vfxmoney/shared/popUp/unload_money_popup.dart';

class VortexCardWalletWidget extends StatefulWidget {
  const VortexCardWalletWidget({Key? key}) : super(key: key);

  static const double cardHeight = 220;

  @override
  State<VortexCardWalletWidget> createState() => _VortexCardWalletWidgetState();
}

class _VortexCardWalletWidgetState extends State<VortexCardWalletWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final index = _pageController.page?.round() ?? 0;
      if (_currentPage != index) {
        _currentPage = index;
        context.read<DashboardBloc>().add(CardChanged(index));
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
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }

        if (state is DashboardLoaded) {
          final cards = state.cards;
          final isDetailsVisible = state.isCardDetailsVisible;

          final details = state.cardDetails;
          if (cards.isEmpty) {
            return const Center(child: Text('No cards available'));
          }

          return Column(
            children: [
              /// 🔥 CARD SLIDER (UNCHANGED UI)
              SizedBox(
                height: VortexCardWalletWidget.cardHeight,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FlippableCard(
                        cardData: CardData(
                          balance: card.balance, // NOT USED ON CARD
                          cardNumber: isDetailsVisible
                              ? details!.cardNumber
                              : '**** **** **** ${card.cardNumber}',

                          holderName: card.cardHolderName,
                          cardId: card.cardId,
                          cvv: isDetailsVisible ? details!.cvv : '***',
                          expiryDate: isDetailsVisible
                              ? '${details!.expMonth}/${details!.expYear.substring(2)}'
                              : '--/--',
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// 🔸 PAGE INDICATOR (UNCHANGED UI)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cards.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: state.activeIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state.activeIndex == index
                          ? const Color(0xFF4CAF50)
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// 🔥 BALANCE CARD (SAME AS STATIC UI)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.3),
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
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.secondary,
                              textStyle: 'jb',
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                final card = state.activeCard;

                                context.read<DashboardBloc>().add(
                                  FetchCardBalance(
                                    cardId: int.parse(card.cardId),
                                    cardHolderId: int.parse(card.cardHolderId),
                                  ),
                                );
                              },
                              child: Icon(
                                state.isBalanceVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 18,
                              ),
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
                        state.isBalanceVisible
                            ? '${state.visibleBalance ?? '0.00'} ${state.currency ?? ''} '
                            : '****',
                        fontSize: 18,
                        textStyle: 'hb',
                        w: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// 🔥 ACTION BUTTONS (UNCHANGED UI)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.add_card_outlined,
                      'Load',
                      () => LoadMoneyPopup.show(context),
                    ),
                    _buildActionButton(
                      context,
                      Icons.account_balance_wallet_outlined,
                      'Unload',
                      () => UnloadMoneyPopup.show(context),
                    ),
                    _buildActionButton(
                      context,
                      Icons.receipt_long_outlined,
                      'Transaction',
                      () => CreateCardPopup.show(context),
                    ),
                    _buildActionButton(
                      context,
                      Icons.lock_outline,
                      'Hold',
                      null,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 6),
          AppText(
            label,
            fontSize: 10,
            color: Theme.of(context).colorScheme.secondary,
            textStyle: 'jb',
          ),
        ],
      ),
    );
  }
}

/// UI MODEL (UNCHANGED)
class CardData {
  final String balance;
  final String cvv;
  final String cardId;
  final String cardNumber;
  final String holderName;
  final String expiryDate;

  CardData({
    required this.balance,
    required this.cvv,
    required this.cardId,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
  });
}
