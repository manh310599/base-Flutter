import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Service responsible for encrypting and decrypting sensitive data
@singleton
class EncryptionService {
  final FlutterSecureStorage _secureStorage;
  static const String _keyName = 'encryption_key';
  
  late encrypt.Encrypter _encrypter;
  late encrypt.IV _iv;

  EncryptionService(this._secureStorage) {
    _initializeEncryption();
  }

  /// Initialize encryption with a secure key
  Future<void> _initializeEncryption() async {
    // Get or generate encryption key
    String? storedKey = await _secureStorage.read(key: _keyName);
    final String key;
    
    if (storedKey == null) {
      // Generate a new key if none exists
      final keyGen = encrypt.Key.fromSecureRandom(32);
      key = base64Encode(keyGen.bytes);
      await _secureStorage.write(key: _keyName, value: key);
    } else {
      key = storedKey;
    }

    final encryptKey = encrypt.Key.fromBase64(key);
    _iv = encrypt.IV.fromLength(16); // AES uses 16 bytes IV
    _encrypter = encrypt.Encrypter(encrypt.AES(encryptKey));
  }

  /// Encrypt a string
  String encryptData(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64;
  }

  /// Decrypt an encrypted string
  String decryptData(String encryptedData) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  /// Encrypt an object by converting to JSON first
  String encryptObject<T>(T object) {
    final jsonString = jsonEncode(object);
    return encryptData(jsonString);
  }

  /// Decrypt and convert back to an object
  T decryptObject<T>(String encryptedData, T Function(Map<String, dynamic>) fromJson) {
    final decrypted = decryptData(encryptedData);
    return fromJson(jsonDecode(decrypted));
  }
}
