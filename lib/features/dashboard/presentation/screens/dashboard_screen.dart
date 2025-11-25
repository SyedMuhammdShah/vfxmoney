import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/card_widget.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/transaction_widget.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        showProfileHeader: true,
        userName: 'Robert Antonio',
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
            // Wallet Card Widget
            const VortexCardWalletWidget(),
            //const SizedBox(height: 16),
            SizedBox(
              height: 480, // Adjust height based on your needs
              child: TransactionListScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
