import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CountryService {
  static const String _cacheKey = 'cached_countries';

  Future<List<dynamic>> fetchCountries() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

      if (response.statusCode == 200) {
        // Save to cache
        await prefs.setString(_cacheKey, response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      // Fallback to cached version
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        rethrow; // If there's no cache, still throw the error
      }
    }
  }
}
