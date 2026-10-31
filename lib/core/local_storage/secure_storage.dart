import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fridgy/core/local_storage/local_storage_keys.dart';

class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> setAccessToken(String value) {
    return _storage.write(key: LocalStorageKeys.accessToken, value: value);
  }

  Future<String> getAccessToken() async {
    try {
      return await _storage.read(key: LocalStorageKeys.accessToken) ?? '';
    } catch (_) {
      try {
        await _storage.delete(key: LocalStorageKeys.accessToken);
      } catch (_) {}
      return '';
    }
  }

  Future<void> setRefreshToken(String value) {
    return _storage.write(key: LocalStorageKeys.refreshToken, value: value);
  }

  Future<String> getRefreshToken() async {
    try {
      return await _storage.read(key: LocalStorageKeys.refreshToken) ?? '';
    } catch (_) {
      try {
        await _storage.delete(key: LocalStorageKeys.refreshToken);
      } catch (_) {}
      return '';
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: LocalStorageKeys.accessToken);
    await _storage.delete(key: LocalStorageKeys.refreshToken);
  }
}
