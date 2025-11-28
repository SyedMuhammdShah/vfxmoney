import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/theme/app_theme.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/delete_bloc/delete_account_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_state.dart';

import 'package:vfxmoney/firebase_options.dart';
import 'package:vfxmoney/shared/widgets/connection_alert.dart';

import 'core/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();

  // No theme logic here anymore → will move inside MyApp using BlocBuilder
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<AuthBloc>(), lazy: true),
        BlocProvider(
          create: (context) => locator<DeleteAccountBloc>(),
          lazy: true,
        ),
        BlocProvider(create: (context) => locator<ThemeBloc>()), // NEW
      ],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: const [MyApp(), ConnectionAlert()],
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _lastBackPressTime;

  // Handle back button press
  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    // If first time pressing back or more than 2 seconds have passed
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      // Show snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return false; // Don't exit
    }

    // If pressed twice within 2 seconds, show confirmation dialog
    return await _showExitConfirmationDialog();
  }

  // Show confirmation dialog before exiting
  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    GoTransition.defaultCurve = Curves.easeInOut;
    GoTransition.defaultDuration = const Duration(milliseconds: 600);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // 🔥 Update System UI Icons based on theme
        _setSystemUI(state.themeMode);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'VFX Money',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode, // <-- Bloc-controlled theme
          routerConfig: AppRouter.router,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return SafeArea(
              top: false,
              bottom: false,
              left: false,
              right: false,
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    viewInsets: mediaQuery.viewInsets,
                    padding: mediaQuery.padding,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 🔥 Dynamic status/navigation bar colors based on theme mode
  void _setSystemUI(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.tealShade,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.tealShade,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
