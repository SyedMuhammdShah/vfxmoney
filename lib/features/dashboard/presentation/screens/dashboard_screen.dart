import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/card_widget.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/transaction_widget.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

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
    return BlocProvider(
      create: (_) {
        final bloc = locator<DashboardBloc>();
        bloc.add(FetchCards(int.parse(user.cardHolderId)));
        return bloc;
      },
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          // ✅ SHOW SUCCESS TOAST AFTER CARD CREATION
          if (state is DashboardLoaded &&
              state.lastAction == DashboardAction.cardCreated) {
            successToast(msg: state.message ?? 'Success');
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Dashboard',
            showProfileHeader: true,
            userName: user?.name ?? 'Guest User',
          ),
          body: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }

              if (state is DashboardLoaded) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: const [
                    SizedBox(height: 16),
                    VortexCardWalletWidget(),
                    SizedBox(height: 32),
                    SizedBox(height: 480, child: TransactionListScreen()),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
