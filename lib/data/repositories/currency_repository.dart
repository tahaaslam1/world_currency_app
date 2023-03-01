import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:world_currency_app/data/exceptions/currency_exception.dart';
import 'package:world_currency_app/logger.dart';
import 'package:world_currency_app/models/currency.dart';

class CurrencyRepository {
  Future<Map<String, dynamic>> getCurrencyRate({required Currency? baseCurrency}) async {
    final response = await http.get(
      Uri.parse(
        'https://currency.dizyn.top/${baseCurrency!.currencyCode}',
      ),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );
    logger.d(response.body);
    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw CurrencyException(data['data']['error']);
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    }
  }
}
