  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:vfxmoney/core/navigation/route_enums.dart';
  import 'package:vfxmoney/features/dashboard/presentation/widgets/card_widget.dart';
  import 'package:vfxmoney/features/dashboard/presentation/widgets/transaction_widget.dart';
  import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
  import 'package:vfxmoney/core/services/service_locator.dart';
  import 'package:vfxmoney/core/services/storage_service.dart';

  class DashboardScreen extends StatefulWidget {
    const DashboardScreen({super.key});

    @override
    State<DashboardScreen> createState() => _DashboardScreenState();
  }

  class _DashboardScreenState extends State<DashboardScreen> {
    late final user;

    @override
    void initState() {
      super.initState();
      user = locator<StorageService>().getUser;

      // Debug
      print("Dashboard loaded user: ${user?.toJson()}");
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Dashboard',
          showProfileHeader: true,
          userName: user?.name ?? 'Guest User',
          avatarUrl:
              'https://img.icons8.com/?size=128&id=tZuAOUGm9AuS&format=png',
          onAvatarTap: () {
            context.pushNamed(Routes.userProfile.name);
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Wallet Widget Example With Data
              VortexCardWalletWidget(cards: [],),

              SizedBox(height: 480, child: TransactionListScreen()),
            ],
          ),
        ),
      );
    }
  }
