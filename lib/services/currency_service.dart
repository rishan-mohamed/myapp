// lib/services/currency_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiUrl = 'https://v6.exchangerate-api.com/v6/9865f910b1d7ecc20e7f1581/latest/';

  Future<Map<String, double>> fetchExchangeRates(String currencyCode) async {
    final response = await http.get(Uri.parse('$apiUrl$currencyCode'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['conversion_rates'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toDouble()));
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}