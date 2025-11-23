import 'package:flutter/material.dart';
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
        onAvatarTap: () => print('avatar tapped'),
      ),
      body: Center(child: Text('Dashboard Screen')),
    );
  }
}
