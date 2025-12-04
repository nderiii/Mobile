import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class StockApis {
  final String apiKey = '2R2U4ZQFS2BNG70O';

  // Cache to avoid API spam
  final Map<String, double> _cache = {};

  // -----------------------------
  // Load symbol list from JSON
  // -----------------------------
  Future<List<dynamic>> loadSymbols() async {
    final jsonData = await rootBundle.loadString("assets/stocks.json");
    return jsonDecode(jsonData);
  }

  // -----------------------------
  // Safe HTTP fetch wrapper
  // -----------------------------
  Future<Map<String, dynamic>?> _fetch(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return null;
      return jsonDecode(res.body);
    } catch (e) {
      print("Request error → $e");
      return null;
    }
  }

  // -----------------------------
  // Fetch stock price
  // -----------------------------
  Future<double?> getStockPrice(String symbol) async {
    if (_cache.containsKey(symbol)) return _cache[symbol];

    final url =
        "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey";

    final data = await _fetch(url);
    if (data == null) return null;

    final quote = data["Global Quote"];
    if (quote == null) return null;

    final price = double.tryParse(quote["05. price"] ?? "");
    if (price != null) _cache[symbol] = price;

    return price;
  }

  // -----------------------------
  // Fetch crypto price (USD)
  // -----------------------------
  Future<double?> getCryptoPrice(String symbol) async {
    if (_cache.containsKey(symbol)) return _cache[symbol];

    final url =
        "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$symbol&to_currency=USD&apikey=$apiKey";

    final data = await _fetch(url);
    if (data == null) return null;

    final rate = data["Realtime Currency Exchange Rate"];
    if (rate == null) return null;

    final price = double.tryParse(rate["5. Exchange Rate"] ?? "");
    if (price != null) _cache[symbol] = price;

    return price;
  }

  // -----------------------------
  // Fetch all prices in parallel
  // -----------------------------
  Future<Map<String, double?>> fetchAllPricesParallel() async {
    final symbols = await loadSymbols();

    Map<String, Future<double?>> futures = {};

    for (var item in symbols) {
      final symbol = item["symbol"];
      final type = item["type"];

      futures[symbol] = (type == "crypto")
          ? getCryptoPrice(symbol)
          : getStockPrice(symbol);
    }

    // Wait for all requests
    final results = await Future.wait(futures.values);

    final Map<String, double?> finalMap = {};
    int index = 0;

    for (var key in futures.keys) {
      finalMap[key] = results[index];
      index++;
    }

    return finalMap;
  }
}
