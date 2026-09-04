import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/water.dart';

class StorageService {
  static const String storageKey = 'abastece_plus_agua';

  Future<List<Water>> loadWater() async {
    final prefs = await SharedPreferences.getInstance();

    final saved = prefs.getString(storageKey);

    if (saved == null || saved.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(saved);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (item) => Water.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveWater(List<Water> water) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      water.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(storageKey, encoded);
  }
}
