import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'models/currency_rate.dart';

class CurrencyRepository {
  final String baseUrl = "https://v6.exchangerate-api.com/v6/9865f910b1d7ecc20e7f1581/latest";

  Future<CurrencyRate> getRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$baseUrl/$baseCurrency'));
    if (response.statusCode == 200) {
      return CurrencyRate.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load exchange rates");
    }
  }
}
