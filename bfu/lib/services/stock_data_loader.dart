import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StockDataLoader {
  Future<Map<String, dynamic>> loadStockJson() async {
    final jsonString = await rootBundle.loadString('assets/stocks.json');
    return jsonDecode(jsonString);
  }
}
