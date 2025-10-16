import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wellness_model.dart';

abstract class BaseRepository<T> {
  final String _key;
  final SharedPreferences _prefs;

  BaseRepository(this._key, this._prefs);

  // Abstract methods to be implemented by subclasses
  Map<String, dynamic> toJson(T item);
  T fromJson(Map<String, dynamic> json);
  String generateId();

  // Helper method to get ID from item
  String _getIdFromItem(T item) {
    if (item is WaterLogModel) {
      return (item as WaterLogModel).id;
    } else if (item is SleepLogModel) {
      return (item as SleepLogModel).id;
    } else if (item is NutritionLogModel) {
      return (item as NutritionLogModel).id;
    } else {
      // Fallback to reflection or assume item has an 'id' property
      // This is a workaround for the generic type
      return (item as dynamic).id as String;
    }
  }

  // Generic CRUD operations
  Future<List<T>> getAll() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<T?> getById(String id) async {
    final items = await getAll();
    try {
      return items.firstWhere((item) => _getIdFromItem(item) == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> save(T item) async {
    final items = await getAll();
    final existingIndex = items.indexWhere(
      (existing) => _getIdFromItem(existing) == _getIdFromItem(item),
    );

    if (existingIndex >= 0) {
      items[existingIndex] = item;
    } else {
      items.add(item);
    }

    await _saveAll(items);
  }

  Future<void> delete(String id) async {
    final items = await getAll();
    items.removeWhere((item) => _getIdFromItem(item) == id);
    await _saveAll(items);
  }

  Future<void> deleteAll() async {
    await _prefs.remove(_key);
  }

  Future<void> _saveAll(List<T> items) async {
    final jsonList = items.map((item) => toJson(item)).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_key, jsonString);
  }
}

// Mixin for repositories that need to track user-specific data
mixin UserDataRepository<T> {
  String getUserId();

  String getUserKey(String baseKey) {
    return '${baseKey}_${getUserId()}';
  }
}
