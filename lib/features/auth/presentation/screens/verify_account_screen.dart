import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class VerifyAccountScreen extends StatelessWidget {
  final dynamic extra;

  const VerifyAccountScreen({super.key, this.extra});

  // --- Helper methods ---
  String _maskEmail(String email) {
    if (email.isEmpty) return 'Not provided';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }
    return '${username.substring(0, 2)}***${username[username.length - 1]}@$domain';
  }

  String _maskPhone(String phone) {
    if (phone.isEmpty) return 'Not provided';
    if (phone.length <= 4) return phone;
    return '${phone.substring(0, 3)} *** ${phone.substring(phone.length - 3)}';
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    showToast(msg: message);
  }

  /// Try to resolve a UserModel (UserEntity subclass) from different sources:
  /// 1) Authenticated state -> state.authUser.user
  /// 2) extra if it's AuthUserEntity
  /// 3) extra if it's UserModel
  /// 4) extra if it's Map (either contains 'user' or user fields)
  /// 5) StorageService.getUser()
  Future<UserModel?> _resolveUser(
    BuildContext context,
    AuthState state,
    dynamic extra,
  ) async {
    // 1) from bloc state (preferred)
    if (state is Authenticated) {
      return state.authUser.user != null
          ? UserModel.fromJson((state.authUser.user as UserModel).toJson())
          : state.authUser.user as UserModel?;
      // Note: state.authUser.user might be UserEntity; we will try to convert via toJson if it's actually a UserModel.
    }

    // 2) if extra is AuthUserEntity
    if (extra is AuthUserEntity) {
      return extra.user is UserModel
          ? extra.user as UserModel
          : extra.user != null
          ? UserModel.fromJson((extra.user as dynamic).toJson())
          : null;
    }

    // 3) if extra is UserModel
    if (extra is UserModel) return extra;

    // 4) if extra is Map
    if (extra is Map<String, dynamic>) {
      final map = extra;
      // If user is nested under 'user'
      if (map['user'] is Map<String, dynamic>) {
        try {
          return UserModel.fromJson(map['user'] as Map<String, dynamic>);
        } catch (_) {
          // fallthrough
        }
      }
      // If map itself looks like a user
      if (map.containsKey('_id') || map.containsKey('email')) {
        try {
          return UserModel.fromJson(map);
        } catch (_) {
          // fallthrough
        }
      }
    }

    // 5) fallback: try to get user from storage
    try {
      final storage = locator<StorageService>();
      final stored = storage.getUser; // your StorageService returns UserModel?
      if (stored is UserModel) return stored;
      // if (stored != null) {
      //   // If storage returns a plain map, try parsing
      //   if (stored is Map<String, dynamic>) {
      //     return UserModel.fromJson(stored);
      //   }
      // }
    } catch (_) {
      // ignore
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is OtpSent) {
          final user = await _resolveUser(context, state, extra);
          final valueToSend = (state.verificationType == 'email')
              ? user?.email ?? ''
              : user?.phone ?? '';
          if (context.mounted) {
            context.pushNamed(
              Routes.otp.name,
              extra: {
                "verificationType": state.verificationType,
                "source": "signup",
                "email": valueToSend,
              },
            );
          }
        } else if (state is Authenticated) {
          final user = state.authUser.user;
          if (user != null &&
              (user.isEmailVerified) &&
              (user.isPhoneVerified)) {
            _showSnackBar(context, "Account fully verified!", Colors.green);
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                context.goNamed(
                  Routes.loginSuccess.name,
                  extra: {
                    "title": "Phone Number and Email verified.",
                    "subtitle": "You have successfully verified your account.",
                    "source": "signup",
                  },
                );
              }
            });
          }
        } else if (state is AuthError) {
          _showSnackBar(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return FutureBuilder<UserModel?>(
          future: _resolveUser(context, state, extra),
          builder: (context, snapshot) {
            // still resolving
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data;

            // if we still don't have a user, redirect to login (avoid stuck loader)
            if (user == null) {
              // give one microtask to navigate so build completes first
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.isCurrent ?? true) {
                  context.goNamed(Routes.login.name);
                }
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final email = user.email;
            final phone = user.phone;
            final isEmailVerified = user.isEmailVerified;
            final isPhoneVerified = user.isPhoneVerified;

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                // appBar: RoundedAppBarWithProfile(
                //   height: 50,
                //   alignTitleCenter: true,
                //   showNameLocation: false,
                //   showProfileImage: false,
                //   showBackButton: false,
                //   showIcons: false,
                //   titleColor: Colors.white,
                // ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Lock Icon
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6F7F1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppIcons.lockIcon),
                          ),
                          const SizedBox(height: 30),

                          const Text(
                            "Verify your account",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            "To secure your account, please verify your identity.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // EMAIL SECTION
                          GestureDetector(
                            onTap: () {
                              if (isEmailVerified) {
                                _showSnackBar(
                                  context,
                                  "Email is already verified",
                                  Colors.blue,
                                );
                              } else {
                                context.read<AuthBloc>().add(
                                  const SendEmailOtpEvent(''),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: isEmailVerified
                                    ? const Color(0xFFE6F7F1)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                                border: isEmailVerified
                                    ? Border.all(
                                        color: AppColors.greenVelvet,
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isEmailVerified
                                        ? Icons.check_circle
                                        : Icons.email_rounded,
                                    color: isEmailVerified
                                        ? Colors.green
                                        : AppColors.greenVelvet,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Email address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            if (isEmailVerified) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  "Verified",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _maskEmail(email),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isEmailVerified
                                        ? Icons.check_circle_outline
                                        : Icons.chevron_right,
                                    color: isEmailVerified
                                        ? Colors.green
                                        : Colors.black38,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // PHONE SECTION
                          GestureDetector(
                            onTap: () {
                              if (!isEmailVerified) {
                                _showSnackBar(
                                  context,
                                  "Please verify your email first",
                                  Colors.blue,
                                );
                                return;
                              }
                              if (isPhoneVerified) {
                                _showSnackBar(
                                  context,
                                  "Phone already verified",
                                  Colors.blue,
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                const SendPhoneOtpEvent(''),
                              );
                            },
                            child: Opacity(
                              opacity: !isEmailVerified ? 0.5 : 1.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isPhoneVerified
                                      ? const Color(0xFFE6F7F1)
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: isPhoneVerified
                                      ? Border.all(
                                          color: AppColors.greenVelvet,
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isPhoneVerified
                                          ? Icons.check_circle
                                          : Icons.phone_iphone,
                                      color: isPhoneVerified
                                          ? Colors.green
                                          : AppColors.greenVelvet,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Phone number",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              if (isPhoneVerified) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Verified",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _maskPhone(phone),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isPhoneVerified
                                          ? Icons.check_circle_outline
                                          : Icons.chevron_right,
                                      color: isPhoneVerified
                                          ? Colors.green
                                          : Colors.black38,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (!isEmailVerified || !isPhoneVerified) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange.shade700,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      !isEmailVerified
                                          ? "Please verify your email first"
                                          : "Please verify your phone number",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
