// imports
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' show Hmac, sha256;
import 'package:pointycastle/export.dart' show PaddedBlockCipherParameters, PaddedBlockCipherImpl, PKCS7Padding, CBCBlockCipher, AESEngine, ParametersWithIV, KeyParameter;
import 'package:flutter/foundation.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtEncryptionService {
  // keep your existing constructor that accepts base64 key
  late final String _secretHex;      // for jwt library (hex string)
  late final Uint8List _secretBytes; // raw bytes for AES/HMAC
  late final SecretKey _jwtSecretKey;

  JwtEncryptionService(String secretBase64) {
    final cleaned = secretBase64.startsWith('base64:')
        ? secretBase64.substring('base64:'.length)
        : secretBase64;

    // Raw key bytes
    final keyBytes = base64.decode(cleaned);
    _secretBytes = Uint8List.fromList(keyBytes);

    // hex string representation used earlier for dart_jsonwebtoken compatibility
    _secretHex = keyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    _jwtSecretKey = SecretKey(_secretHex);
  }

  // ---------- JWT SIGN/VERIFY (unchanged) ----------
  String encrypt(Map<String, dynamic> payload, {Map<String, dynamic>? extraClaims}) {
    final jwt = JWT(
      {
        'data': payload,
        if (extraClaims != null) ...extraClaims,
      },
    );
    return jwt.sign(_jwtSecretKey, algorithm: JWTAlgorithm.HS256);
  }

  Map<String, dynamic> decryptJwt(String token) {
    final jwt = JWT.verify(token, _jwtSecretKey);
    final payload = jwt.payload;
    if (payload == null) return {};
    if (payload.containsKey('data')) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) return data;
      if (data is String) {
        try {
          return json.decode(data) as Map<String, dynamic>;
        } catch (_) {
          return {'raw': data};
        }
      }
    }
    if (payload is Map<String, dynamic>) return payload;
    return {};
  }

  // ---------- Laravel decrypt implementation ----------
  /// Decrypts a Laravel encrypted string (the base64-json blob).
  /// Returns a Map<String, dynamic> for JSON payload or throws on verification/decrypt failure.
  Map<String, dynamic> decryptLaravelPayload(String laravelCipher) {
    // Step 1: base64-decode -> JSON string
    final decoded = base64.decode(laravelCipher);
    final decodedStr = utf8.decode(decoded);

    final Map<String, dynamic> envelope = jsonDecode(decodedStr) as Map<String, dynamic>;
    final String ivBase64 = envelope['iv'] as String;
    final String valueBase64 = envelope['value'] as String;
    final String mac = envelope['mac'] as String;

    // Step 2: verify MAC (HMAC-SHA256 of ivBase64 + valueBase64 using key bytes)
    final verifier = Hmac(sha256, _secretBytes); // crypto Hmac
    final macInput = utf8.encode(ivBase64 + valueBase64);
    final computedMac = verifier.convert(macInput).toString();

    if (!constantTimeEquals(computedMac, mac)) {
      throw Exception('MAC mismatch — data integrity check failed');
    }

    // Step 3: decode iv and ciphertext, then AES-256-CBC decrypt with PKCS7 padding
    final ivBytes = base64.decode(ivBase64);
    final cipherBytes = base64.decode(valueBase64);

    final plainBytes = _aesCbcPkcs7Decrypt(cipherBytes, _secretBytes, ivBytes);

    final plainText = utf8.decode(plainBytes);
    // try to parse JSON
    try {
      final obj = jsonDecode(plainText);
      if (obj is Map<String, dynamic>) return obj;
      // if not a map, return as wrapper
      return {'raw': obj};
    } catch (_) {
      return {'raw': plainText};
    }
  }

  // helper to perform AES-256-CBC decryption with PKCS7 using pointycastle
  Uint8List _aesCbcPkcs7Decrypt(Uint8List cipherText, Uint8List key, Uint8List iv) {
    final paddedCipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );

    final params = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
      null,
    );

    paddedCipher.init(false, params); // false = decrypt

    return paddedCipher.process(cipherText);
  }

  // constant time equals to avoid timing attacks
  bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  // ---------- Combined helper: try jwt first, else laravel ----------
  /// Tries to decrypt first as JWT, then as Laravel encrypted blob.
  /// Returns Map<String, dynamic> on success, or throws Exception if both fail.
  Map<String, dynamic> decryptAny(String tokenOrBlob) {
    // try JWT
    try {
      return decryptJwt(tokenOrBlob);
    } catch (_) {
      // ignore
    }

    // try Laravel-style decrypt
    try {
      return decryptLaravelPayload(tokenOrBlob);
    } catch (e) {
      if (kDebugMode) {
        print('decryptAny: both JWT and Laravel decrypt failed: $e');
      }
      rethrow;
    }
  }
}
