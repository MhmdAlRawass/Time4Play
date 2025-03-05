import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryProvider extends ChangeNotifier {
  List<dynamic> _countries = [];
  bool _isLoading = false;

  List<dynamic> get countries => _countries;
  bool get isLoading => _isLoading;

  Future<void> fetchCountries() async {
    if (_countries.isNotEmpty) return; 

    _isLoading = true;
    notifyListeners();

    const url = 'https://restcountries.com/v3.1/all';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _countries = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      _countries = []; // Handle error scenario
    }

    _isLoading = false;
    notifyListeners();
  }
}
