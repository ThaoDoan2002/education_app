import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token, int expires) async {

    final expiresAt = DateTime.now().add(Duration(seconds: expires));
    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'expires_at', value: expiresAt.toIso8601String());
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'access_token');
    final expiresAtStr = await _storage.read(key: 'expires_at');

    if (token == null || expiresAtStr == null) return null;

    final expiresAt = DateTime.tryParse(expiresAtStr);
    if (expiresAt == null || DateTime.now().isAfter(expiresAt)) {
      await clearToken();
      return null;
    }

    return token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'expires_at');
  }
}