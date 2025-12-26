// lib/core/services/api_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vfxmoney/core/errors/exceptions.dart';
import 'package:vfxmoney/core/interceptors/interceptors.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/core/utils/api_error_parser.dart';
import 'device_data_service.dart';
import 'package:vfxmoney/core/services/jwt_encryption_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService pref = locator<StorageService>();
  JwtEncryptionService get _jwtService => locator<JwtEncryptionService>();
  final DeviceInfoService deviceInfoService = locator<DeviceInfoService>();

  ApiService({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? "",
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    debugPrint("Base URL: $baseUrl");

    // Add custom interceptor that decrypts & logs readable request/response
    _dio.interceptors.add(DecryptAndLogInterceptor(_jwtService));

    // Keep a lightweight LogInterceptor for basic info but do NOT log bodies,
    // because we handle decrypted logging in DecryptAndLogInterceptor.
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: false,
        requestHeader: true,
        error: true,
        requestBody: false,
        responseHeader: false,
        request: true,
        logPrint: (object) => log(object.toString()),
      ),
    );

    // Token blacklist / auth interceptor (unchanged)
    _dio.interceptors.add(AuthInterceptor());
  }

  Map<String, String> _buildHeaders(
    bool isAuthorize,
    Map<String, String>? extraHeaders, {
    String? token,
  }) {
    log(name: 'deviceId', deviceInfoService.safeDeviceID);
    Map<String, String> apiHeaders = {
      'devicemodel': deviceInfoService.safeDeviceName,
      'deviceuniqueid': deviceInfoService.safeDeviceID,
    };

    if (isAuthorize) {
      apiHeaders['Authorization'] = "Bearer ${token ?? pref.getToken}";
    }

    if (extraHeaders != null) {
      apiHeaders.addAll(extraHeaders);
    }

    return apiHeaders;
  }

  /// Helper: try to decrypt a full-string response (JWT or Laravel encrypted blob) -> returns Map or null
  Map<String, dynamic>? _tryDecryptFullString(dynamic responseData) {
    try {
      if (responseData is String && responseData.trim().isNotEmpty) {
        // Attempt decrypt via combined helper (tries JWT then Laravel-style decrypt)
        final decoded = _jwtService.decryptAny(responseData);
        return decoded;
      }
    } catch (e) {
      if (kDebugMode) {
        log('Full-response decrypt failed: $e');
      }
    }
    return null;
  }

  /// POST request
  /// endpoint can be '' to post to baseUrl directly.
  Future<Response> post(
    String endpoint, {
    dynamic payload,
    Map<String, dynamic>? queryParams,
    bool isAuthorize = false,
    String? token,
    Map<String, String>? headers,
    void Function(int, int)? onSendProgress,
    bool encryptPayload = false,
    bool attemptDecryptResponse = true, // attempt basic decryption if needed
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(
        isAuthorize,
        headers,
        token: token,
      );

      final bool isMultipart = payload is FormData;
      final dioHeaders = {
        ...apiHeaders,
        'Content-Type': isMultipart
            ? 'multipart/form-data'
            : 'application/json',
      };

      dynamic bodyToSend = payload;

      if (encryptPayload && !isMultipart) {
        Map<String, dynamic> payloadMap;
        if (payload is Map<String, dynamic>) {
          payloadMap = payload;
        } else {
          payloadMap = jsonDecode(jsonEncode(payload)) as Map<String, dynamic>;
        }
        final encrypted = _jwtService.encrypt(payloadMap);
        // server expects {"payload": "<jwt or laravel-encrypted-string>"}
        bodyToSend = {'payload': encrypted};
        dioHeaders['X-Payload-Encrypted'] = '1';
      }

      log(name: 'header', dioHeaders.toString());
      log(name: 'TOKE', token ?? pref.getToken ?? '');
      // Note: request body logging will be done in DecryptAndLogInterceptor
      final response = await _dio.post(
        endpoint,
        data: bodyToSend,
        queryParameters: queryParams,
        options: Options(headers: dioHeaders),
        onSendProgress: (count, total) {
          log(name: 'Progress', "$count/$total");
          if (onSendProgress != null) onSendProgress(count, total);
        },
      );

      // Try to decrypt full string response (server returns encrypted string)
      if (attemptDecryptResponse) {
        final full = _tryDecryptFullString(response.data);
        if (full != null) {
          response.data = full;
          return response;
        }

        // If response.data is Map and contains 'data' as encrypted string -> decrypt it
        if (response.data is Map<String, dynamic>) {
          final respMap = Map<String, dynamic>.from(response.data as Map);
          final maybeData = respMap['data'];
          if (maybeData is String) {
            try {
              final decrypted = _jwtService.decryptAny(maybeData);
              respMap['data'] = decrypted;
              response.data = respMap;
            } catch (e) {
              if (kDebugMode) print('Decrypt of resp.data failed: $e');
            }
          }
        }
      }

      return response;
    } on DioException catch (e) {
      final raw = e.response?.data;

      // Try decrypting full response first
      try {
        final full = _tryDecryptFullString(raw);
        if (full != null) {
          final message = ApiErrorParser.extractMessage(full);
          throw ServerException(message);
        }
      } catch (_) {}

      // If already a Map (Laravel style)
      if (raw is Map<String, dynamic>) {
        final message = ApiErrorParser.extractMessage(raw);
        throw ServerException(message);
      }

      // Fallback
      throw ServerException(e.message ?? 'Network error. Please try again.');
    }
  }

  /// GET request (endpoint optional, uses baseUrl if empty)
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool isAuthorize = false,
    dynamic payload,
    Map<String, String>? headers,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(isAuthorize, headers);

      log(name: 'header', apiHeaders.toString());
      log(name: 'queryParameter', queryParameters.toString());

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        data: payload,
        options: Options(headers: apiHeaders),
      );

      // Attempt full-response decrypt
      final full = _tryDecryptFullString(response.data);
      if (full != null) {
        response.data = full;
        return response;
      }

      // Attempt decrypt of response.data['data'] if it's a string
      if (response.data is Map<String, dynamic>) {
        final respMap = Map<String, dynamic>.from(response.data as Map);
        final maybeData = respMap['data'];
        if (maybeData is String) {
          try {
            final decrypted = _jwtService.decryptAny(maybeData);
            respMap['data'] = decrypted;
            response.data = respMap;
          } catch (e) {
            if (kDebugMode) print('Decrypt of resp.data failed: $e');
          }
        }
      }

      return response;
    } on DioException catch (e) {
      // similar error handling as post
      try {
        final raw = e.response?.data;
        final full = _tryDecryptFullString(raw);
        if (full != null) {
          final message = (full['message'] ?? full.toString()).toString();
          throw ServerException(message);
        }
      } catch (_) {}
      throw ServerException(
        (e.response?.data as Map<String, dynamic>?)?['message'] ??
            e.message ??
            'Something went wrong!',
      );
    }
  }

  Map<String, dynamic> normalizeResponse(dynamic response) {
    if (response is Map && response['raw'] != null) {
      final raw = response['raw'] as String;

      /// Remove PHP serialization wrapper
      final jsonString = raw
          .replaceFirst(RegExp(r'^s:\d+:"'), '')
          .replaceAll(RegExp(r'";$'), '');
          

      return jsonDecode(jsonString) as Map<String, dynamic>;
    }

    return response as Map<String, dynamic>;
  }

  // PUT, DELETE, PATCH follow the same pattern of decrypt attempts as POST/GET.
  // You can implement them similarly if you need them.
}

/// Custom interceptor that decrypts and logs readable request/response for debug.
///
/// - Decrypts request if we sent {"payload": "<encrypted>"} and logs the decrypted request body.
/// - Decrypts response if server returned a raw encrypted string or if response.data['data'] is an encrypted string.
/// - Does not throw on decrypt failure; falls back to original payload.
class DecryptAndLogInterceptor extends Interceptor {
  final JwtEncryptionService _jwt;

  DecryptAndLogInterceptor(this._jwt);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log request headers (already logged by LogInterceptor) — but show readable body if encrypted
    try {
      final body = options.data;
      dynamic toLog = body;
      if (body is Map &&
          body.containsKey('payload') &&
          body['payload'] is String) {
        // try to decrypt payload for readable logging
        try {
          final decrypted = _jwt.decryptAny(body['payload'] as String);
          toLog = decrypted;
        } catch (e) {
          if (kDebugMode) log('Request payload decrypt failed: $e');
          toLog = body; // fallback
        }
      }
      if (kDebugMode) {
        log(
          '➡️ HTTP ${options.method} ${options.uri}\nHeaders: ${options.headers}\nBody: $toLog',
        );
      }
    } catch (e) {
      if (kDebugMode) log('DecryptAndLogInterceptor.onRequest error: $e');
    } finally {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final data = response.data;
      dynamic toLog = data;

      // 1) If whole response is a string -> try decrypt (JWT or Laravel)
      if (data is String) {
        try {
          final decrypted = _jwt.decryptAny(data);
          toLog = decrypted;
          response.data = decrypted;
        } catch (e) {
          if (kDebugMode) log('Response full decrypt failed: $e');
        }
      } else if (data is Map && data['data'] is String) {
        // 2) If data field is encrypted string -> decrypt it
        try {
          final decrypted = _jwt.decryptAny(data['data'] as String);
          final m = Map<String, dynamic>.from(data);
          m['data'] = decrypted;
          toLog = m;
          response.data = m;
        } catch (e) {
          if (kDebugMode) log('Response data decrypt failed: $e');
        }
      }

      if (kDebugMode) {
        log(
          '⬅️ HTTP ${response.requestOptions.method} ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nResponse: $toLog',
        );
      }
    } catch (e) {
      if (kDebugMode) log('DecryptAndLogInterceptor.onResponse error: $e');
    } finally {
      super.onResponse(response, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      final raw = err.response?.data;
      if (raw != null) {
        try {
          if (raw is String) {
            final decrypted = _jwt.decryptAny(raw);
            if (kDebugMode) log('❗HTTP ERROR decrypted body: $decrypted');
          } else if (raw is Map && raw['data'] is String) {
            final decrypted = _jwt.decryptAny(raw['data'] as String);
            if (kDebugMode) log('❗HTTP ERROR decrypted data: $decrypted');
          }
        } catch (e) {
          if (kDebugMode)
            log('DecryptAndLogInterceptor.onError decrypt failed: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) log('DecryptAndLogInterceptor.onError: $e');
    } finally {
      super.onError(err, handler);
    }
  }
}
