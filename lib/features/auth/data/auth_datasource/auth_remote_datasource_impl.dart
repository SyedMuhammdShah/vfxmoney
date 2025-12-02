import 'dart:convert';

import 'package:dio/dio.dart';
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

  @override
  Future<AuthUserModel> login(LoginParams params) async {
    try {
      // Ensure params.toJson() contains "route": "auth.login"
      final payload = params.toJson();

      // POST to base URL (empty endpoint) — backend reads 'route' from payload
      // Set encryptPayload according to backend requirement. Here kept false as you indicated.
      final response = await apiService.post(
        '', // empty string -> post to baseUrl
        payload: payload,
        isAuthorize: false,
        encryptPayload: false,
      );

      final resp = response.data;
      if (resp == null) {
        throw ServerException('Empty response from server');
      }

      // Helper to convert various shapes into a Map<String, dynamic> for user data
      Map<String, dynamic>? _extractDataMap(dynamic r) {
        try {
          // 1) If already a Map and contains 'success' and 'data' as Map → use data
          if (r is Map<String, dynamic>) {
            if (r['success'] != null && r['data'] != null) {
              final d = r['data'];
              if (d is Map<String, dynamic>)
                return Map<String, dynamic>.from(d);
              if (d is String && d.trim().isNotEmpty) {
                // maybe encrypted string or JSON string
                try {
                  final decrypted = jwtService.decryptAny(d);
                  return Map<String, dynamic>.from(decrypted);
                } catch (_) {
                  try {
                    return Map<String, dynamic>.from(jsonDecode(d) as Map);
                  } catch (_) {}
                }
              }
            }

            // 2) If map looks like the user object directly (contains id or email or token)
            if (r.containsKey('id') ||
                r.containsKey('email') ||
                r.containsKey('token')) {
              return Map<String, dynamic>.from(r);
            }

            // 3) If top-level 'data' is present as Map → return it
            if (r['data'] is Map<String, dynamic>) {
              return Map<String, dynamic>.from(r['data']);
            }
          }

          // 4) If server returned a plain encrypted string (Laravel encrypted blob)
          if (r is String && r.trim().isNotEmpty) {
            try {
              final decrypted = jwtService.decryptAny(r);
              // decrypted might be { success, message, data: {...} } or directly the data
              if (decrypted is Map<String, dynamic>) {
                if (decrypted['data'] is Map<String, dynamic>) {
                  return Map<String, dynamic>.from(decrypted['data']);
                }
                if (decrypted.containsKey('id') ||
                    decrypted.containsKey('token')) {
                  return Map<String, dynamic>.from(decrypted);
                }
                // If decrypted contains nested 'data' as string/json, try that
                if (decrypted['data'] is String) {
                  try {
                    final nested = jwtService.decryptAny(
                      decrypted['data'] as String,
                    );
                    if (nested is Map<String, dynamic>)
                      return Map<String, dynamic>.from(nested);
                  } catch (_) {}
                }
              }
            } catch (_) {
              // not decryptable — maybe plain json string
              try {
                final parsed = jsonDecode(r);
                if (parsed is Map<String, dynamic>) {
                  if (parsed['data'] is Map<String, dynamic>) {
                    return Map<String, dynamic>.from(parsed['data']);
                  }
                  if (parsed.containsKey('id') || parsed.containsKey('token')) {
                    return Map<String, dynamic>.from(parsed);
                  }
                }
              } catch (_) {}
            }
          }
        } catch (_) {
          // swallow and return null below
        }
        return null;
      }

      final dataMap = _extractDataMap(resp);
      if (dataMap == null) {
        throw ServerException('Unexpected login response shape');
      }

      final userModel = AuthUserModel.fromJson(dataMap);

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await storageService.setToken(userModel.token!);
      }

      return userModel;
    } on DioException catch (e) {
      // Try to extract message from an encrypted error body
      try {
        final raw = e.response?.data;
        if (raw is String && raw.trim().isNotEmpty) {
          try {
            final decrypted = jwtService.decryptAny(raw);
            final msg = (decrypted['message'] ?? decrypted.toString())
                .toString();
            throw ServerException(msg);
          } catch (_) {}
        } else if (raw is Map<String, dynamic> && raw['data'] is String) {
          try {
            final decrypted = jwtService.decryptAny(raw['data'] as String);
            final msg = (decrypted['message'] ?? decrypted.toString())
                .toString();
            throw ServerException(msg);
          } catch (_) {}
        }
      } catch (_) {
        // ignore fallback
      }

      final message = (e.response?.data is Map<String, dynamic>)
          ? ((e.response?.data as Map<String, dynamic>)['message'] ??
                'Server error')
          : e.message;
      throw ServerException(message ?? 'Network error');
    }
  }
}
