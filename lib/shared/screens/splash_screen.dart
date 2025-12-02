import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/core/services/session_validator.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/shared/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sessionManager = UserSessionManager();

  @override
  void initState() {
    super.initState();
    // context.read<AuthBloc>().add(LoadUserSessionEvent());
    _sessionManager.validateAndRedirect(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: const EdgeInsets.only(top: 0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// 🔥 FULL-SCREEN GIF BACKGROUND
            Image.asset(
              AppIcons.splashBG, // assets/gif/vortex.gif
              fit: BoxFit.fill,
            ),

            /// Foreground content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // AppLogo(),
                  SizedBox(height: 30),
                  // Text(
                  //   'Loading...',
                  //   style: TextStyle(color: Colors.white70, fontSize: 12),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
