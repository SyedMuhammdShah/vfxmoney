// lib/core/services/shared_preferences_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final SharedPreferences _preferences;
  final ValueNotifier<AuthUserModel?> userNotifier =
      ValueNotifier<AuthUserModel?>(null);

  StorageService(this._preferences) {
    userNotifier.value = getUser;
  }
  static const String _keyUser = 'user';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _fcmToken = 'fcm_Token';
  static const String _token = 'token';
  static const String _keyIsGuest = 'is_guest';
  final _key = 'device_uuid';
  static const String _keyIsSocialLogin = 'is_social_login';

  Future<void> setToken(String token) async {
    if (kDebugMode) {
      print('Token $token');
    }
    await _preferences.setString(_token, token);
  }

  String? get getToken => _preferences.getString(_token);

  Future<void> clearToken() async {
    await _preferences.remove(_token);
    if (kDebugMode) {
      print('Token cleared from storage.');
    }
  }

  Future<void> clearUser() async {
    await _preferences.remove(_keyUser);
    if (kDebugMode) {
      print('_keyUser cleared from storage.');
    }
  }

  Future<void> setUser(dynamic user) async {
    Map<String, dynamic> userMap;

    if (user is AuthUserModel) {
      userMap = user.toJson();
    } else if (user is Map<String, dynamic>) {
      userMap = user;
    } else {
      throw ArgumentError(
        'Invalid user type — must be AuthUserModel or Map<String, dynamic>',
      );
    }

    await _preferences.setString(_keyUser, jsonEncode(userMap));
    userNotifier.value = AuthUserModel.fromJson(userMap);
    if (kDebugMode) {
      print('✅ User saved: $userMap');
    }
  }

  // ✅ Get user
  AuthUserModel? get getUser {
    final data = _preferences.getString(_keyUser);
    if (data == null) return null;

    try {
      final decoded = jsonDecode(data);

      final isSocial = _preferences.getBool(_keyIsSocialLogin) ?? false;
      final userData = isSocial ? decoded['user'] : decoded;

      if (userData == null) return null;

      return AuthUserModel.fromJson(userData);
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ Error decoding user: $e\n$st');
      }
      return null;
    }
  }

  Future<void> setFCMToken(String token) async {
    await _preferences.setString(_fcmToken, token);
  }

  String? get getFCMToken => _preferences.getString(_fcmToken);

  Future<void> setLoginStatus(bool isLoggedIn) async {
    await _preferences.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _preferences.getBool(_keyIsLoggedIn) ?? false;
  }

  // 🔑 Guest Mode Support
  Future<void> setGuestMode(bool isGuest) async {
    await _preferences.setBool(_keyIsGuest, isGuest);
  }

  bool get isGuestMode => _preferences.getBool(_keyIsGuest) ?? false;

  Future<String> getPersistentDeviceUUID() async {
    final existing = _preferences.getString(_key);
    if (existing != null) return existing;

    final uuid = const Uuid().v4();
    await _preferences.setString(_key, uuid);
    return uuid;
  }

  // 🔹 SOCIAL LOGIN FLAG
  Future<void> setSocialLogin(bool isSocial) async {
    await _preferences.setBool(_keyIsSocialLogin, isSocial);
    if (kDebugMode) print('🌐 Social login = $isSocial');
  }

  bool get isSocialLogin => _preferences.getBool(_keyIsSocialLogin) ?? false;
  Future<void> clear() async {
    clearToken();
    clearUser();
    final uuid = _preferences.getString(_key); // Store UUID
    await _preferences.clear();
    if (uuid != null) {
      await _preferences.setString(_key, uuid); // Restore UUID
    }
  }

  /// 🔐 Proper logout – clears session but keeps device UUID
  Future<void> logout() async {
    if (kDebugMode) {
      print('🚪 Logging out user...');
    }

    await _preferences.remove(_token);
    await _preferences.remove(_keyUser);
    await _preferences.remove(_keyIsLoggedIn);
    await _preferences.remove(_keyIsGuest);
    await _preferences.remove(_keyIsSocialLogin);

    // Reset notifier
    userNotifier.value = null;

    if (kDebugMode) {
      print('✅ Logout complete. Session cleared.');
    }
  }
}
