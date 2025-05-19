import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// Service for storing non-sensitive data locally.
@singleton
class LocalStorageService {
  static const String _mainBoxName = 'app_storage';
  late Box<dynamic> _mainBox;

  /// Initializes the local storage service.
  @PostConstruct()
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    _mainBox = await Hive.openBox<dynamic>(_mainBoxName);
  }

  /// Reads a value from storage.
  T? read<T>(String key) {
    return _mainBox.get(key) as T?;
  }

  /// Writes a value to storage.
  Future<void> write<T>(String key, T value) async {
    await _mainBox.put(key, value);
  }

  /// Deletes a value from storage.
  Future<void> delete(String key) async {
    await _mainBox.delete(key);
  }

  /// Clears all values from storage.
  Future<void> clear() async {
    await _mainBox.clear();
  }

  /// Checks if a key exists in storage.
  bool containsKey(String key) {
    return _mainBox.containsKey(key);
  }

  /// Gets all keys in storage.
  List<String> getKeys() {
    return _mainBox.keys.cast<String>().toList();
  }

  /// Gets all values in storage.
  List<dynamic> getValues() {
    return _mainBox.values.toList();
  }

  /// Reads a JSON object from storage.
  Map<String, dynamic>? readMap(String key) {
    final jsonString = read<String>(key);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Writes a JSON object to storage.
  Future<void> writeMap(String key, Map<String, dynamic> value) async {
    await write<String>(key, json.encode(value));
  }

  /// Reads a list of JSON objects from storage.
  List<Map<String, dynamic>>? readMapList(String key) {
    final jsonString = read<String>(key);
    if (jsonString == null) return null;
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.cast<Map<String, dynamic>>();
  }

  /// Writes a list of JSON objects to storage.
  Future<void> writeMapList(String key, List<Map<String, dynamic>> value) async {
    await write<String>(key, json.encode(value));
  }

  /// Opens a custom box.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Closes a custom box.
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }
}
