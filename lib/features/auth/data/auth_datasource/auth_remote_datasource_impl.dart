import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vfxmoney/core/errors/exceptions.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/core/services/jwt_encryption_service.dart';
import 'package:vfxmoney/core/services/api_service.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_datascource.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;
  final StorageService storageService = locator<StorageService>();
  final JwtEncryptionService jwtService = locator<JwtEncryptionService>();

  AuthRemoteDataSourceImpl({required this.apiService});

  // Detect php serialized "s:NNN:"...";" and return inner string or null
  String? _unwrapPhpSerialized(String s) {
    final reg = RegExp(r'''s:\d+:"([\s\S]*)";$''');
    final m = reg.firstMatch(s.trim());
    return m?.group(1);
  }

  // Try to convert dynamic response into Map<String,dynamic> user object
  Map<String, dynamic>? _parseToMap(dynamic resp) {
    try {
      // 1) If already a Map and looks like payload or user
      if (resp is Map<String, dynamic>) {
        // common envelope { success: bool, data: {...} }
        if (resp['data'] is Map<String, dynamic>) {
          return Map<String, dynamic>.from(resp['data'] as Map);
        }
        // sometimes backend returns user directly as top-level map
        if (resp.containsKey('id') ||
            resp.containsKey('token') ||
            resp.containsKey('email')) {
          return Map<String, dynamic>.from(resp);
        }
        // sometimes decrypted payload landed in 'raw' as JSON string
        if (resp['raw'] is String) {
          final rawStr = resp['raw'] as String;
          final unwrapped = _unwrapPhpSerialized(rawStr) ?? rawStr;
          try {
            final parsed = jsonDecode(unwrapped);
            if (parsed is Map<String, dynamic>)
              return Map<String, dynamic>.from(parsed['data'] ?? parsed);
          } catch (_) {
            // ignore and continue
          }
        }
      }

      // 2) If resp is a String: try decrypt (jwt or laravel) then parse JSON
      if (resp is String && resp.trim().isNotEmpty) {
        // try decryptAny (supports JWT and Laravel-style)
        try {
          final decrypted = jwtService.decryptAny(resp);
          if (decrypted is Map<String, dynamic>) {
            // if decrypted contains data envelope
            if (decrypted['data'] is Map<String, dynamic>) {
              return Map<String, dynamic>.from(decrypted['data'] as Map);
            }
            return Map<String, dynamic>.from(decrypted);
          }
        } catch (_) {
          // not decryptable — maybe php-serialized or plain json
          final maybe = _unwrapPhpSerialized(resp) ?? resp;
          try {
            final parsed = jsonDecode(maybe);
            if (parsed is Map<String, dynamic>) {
              if (parsed['data'] is Map<String, dynamic>)
                return Map<String, dynamic>.from(parsed['data']);
              if (parsed.containsKey('id') ||
                  parsed.containsKey('token') ||
                  parsed.containsKey('email')) {
                return Map<String, dynamic>.from(parsed);
              }
            }
          } catch (_) {
            // ignore
          }
        }
      }
    } catch (_) {
      // swallow and return null
    }

    return null;
  }

  @override
  Future<AuthUserModel> login(LoginParams params) async {
    try {
      final payload = params.toJson();
      if (kDebugMode)
        debugPrint('AuthRemoteDataSourceImpl.login payload: $payload');

      final response = await apiService.post(
        '',
        payload: payload,
        isAuthorize: false,
        encryptPayload: false,
      );

      if (kDebugMode)
        debugPrint(
          'AuthRemoteDataSourceImpl.login raw response.data: ${response.data}',
        );

      final resp = response.data;
      final dataMap = _parseToMap(resp);

      if (dataMap == null) {
        if (kDebugMode)
          debugPrint(
            'AuthRemoteDataSourceImpl: failed to parse response -> $resp',
          );
        throw ServerException('Unexpected login response shape');
      }

      if (kDebugMode)
        debugPrint('AuthRemoteDataSourceImpl: extracted dataMap: $dataMap');

      final userModel = AuthUserModel.fromJson(dataMap);

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await storageService.setToken(userModel.token!);
        if (kDebugMode) debugPrint('Token ${userModel.token}');
      }

      // store full user object for later use
      try {
        await storageService.setUser(userModel); // accepts AuthUserModel
        await storageService.setLoginStatus(true);
        if (kDebugMode)
          debugPrint('Saved user to StorageService and set isLoggedIn=true');
      } catch (e, st) {
        if (kDebugMode) debugPrint('Failed to persist user: $e\n$st');
        // don't fail login just because saving to shared_prefs failed
      }

      return userModel;
    } on DioException catch (e) {
      // Try to extract a usable error message (decrypted or php serialized)
      final raw = e.response?.data;

      // attempt decrypted string
      if (raw is String && raw.isNotEmpty) {
        try {
          final decrypted = jwtService.decryptAny(raw);
          final msg = (decrypted is Map && decrypted['message'] != null)
              ? decrypted['message'].toString()
              : decrypted.toString();
          throw ServerException(msg);
        } catch (_) {
          // fallthrough to php/JSON attempt
          final maybe = _unwrapPhpSerialized(raw) ?? raw;
          try {
            final parsed = jsonDecode(maybe);
            if (parsed is Map && parsed['message'] != null) {
              throw ServerException(parsed['message'].toString());
            }
          } catch (_) {
            // ignore
          }
        }
      } else if (raw is Map<String, dynamic>) {
        // if server returned a structured error message
        final msg = raw['message'] ?? raw['error'] ?? raw.toString();
        throw ServerException(msg.toString());
      }

      // fallback to DioException message
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data as Map<String, dynamic>)['message'] ?? e.message
          : e.message;
      throw ServerException(message ?? 'Network error');
    }
  }
}
