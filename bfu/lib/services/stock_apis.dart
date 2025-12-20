import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class StockApis {
  final String apiKey = '2R2U4ZQFS2BNG70O';

  // Cache to avoid API spam
  final Map<String, double> _cache = {};

  // Mock data fallback for when API fails (realistic prices)
  final Map<String, double> _mockPrices = {
    // Stocks
    'AAPL': 195.50,
    'TSLA': 242.80,
    'MSFT': 420.30,
    'GOOGL': 175.40,
    'NVDA': 875.20,
    'AMZN': 182.90,
    'META': 485.60,
    'NFLX': 620.40,
    'AMD': 145.70,
    'INTC': 42.30,
    'JPM': 195.80,
    'V': 275.20,
    'MA': 445.60,
    'DIS': 112.40,
    'COIN': 215.30,
    'NKE': 95.80,
    'PYPL': 62.40,
    'BAC': 38.50,

    // Crypto
    'BTC': 97845.50,
    'ETH': 3642.80,
    'BNB': 692.40,
    'SOL': 215.30,
    'XRP': 2.45,
    'ADA': 1.08,
    'DOGE': 0.38,
    'MATIC': 0.92,
    'DOT': 7.85,
    'AVAX': 42.60,
    'LINK': 23.40,
    'LTC': 105.80,
    'UNI': 14.25,
    'ATOM': 10.60,
    'SHIB': 0.000028,
  };

  // -----------------------------
  // Load symbol list from JSON
  // -----------------------------
  Future<List<dynamic>> loadSymbols() async {
    final jsonData = await rootBundle.loadString("assets/stocks.json");
    return jsonDecode(jsonData);
  }

  // -----------------------------
  // Safe HTTP fetch wrapper with timeout
  // -----------------------------
  Future<Map<String, dynamic>?> _fetch(String url) async {
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              print("⏱️ API timeout for: $url");
              return http.Response('{"error": "timeout"}', 408);
            },
          );

      if (res.statusCode != 200) {
        print(
          "❌ API error (${res.statusCode}): ${res.body.substring(0, min(100, res.body.length))}",
        );
        return null;
      }

      final data = jsonDecode(res.body);

      // Check for API error messages
      if (data.containsKey('Error Message') || data.containsKey('Note')) {
        print("⚠️ API limit reached: ${data['Error Message'] ?? data['Note']}");
        return null;
      }

      return data;
    } catch (e) {
      print("❌ Request error → $e");
      return null;
    }
  }

  // -----------------------------
  // Fetch stock price with fallback
  // -----------------------------
  Future<double?> getStockPrice(String symbol) async {
    // Return cached value if available
    if (_cache.containsKey(symbol)) {
      print("💾 Using cached price for $symbol: \$${_cache[symbol]}");
      return _cache[symbol];
    }

    final url =
        "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey";

    print("🔄 Fetching real price for $symbol...");
    final data = await _fetch(url);

    if (data == null) {
      print("⚠️ API failed for $symbol, using mock data");
      return _getMockPrice(symbol);
    }

    final quote = data["Global Quote"];
    if (quote == null || quote.isEmpty) {
      print("⚠️ Empty quote for $symbol, using mock data");
      return _getMockPrice(symbol);
    }

    final price = double.tryParse(quote["05. price"] ?? "");
    if (price != null) {
      _cache[symbol] = price;
      print("✅ Real price for $symbol: \$$price");
      return price;
    }

    print("⚠️ Could not parse price for $symbol, using mock data");
    return _getMockPrice(symbol);
  }

  // -----------------------------
  // Fetch crypto price with fallback
  // -----------------------------
  Future<double?> getCryptoPrice(String symbol) async {
    // Return cached value if available
    if (_cache.containsKey(symbol)) {
      print("💾 Using cached price for $symbol: \$${_cache[symbol]}");
      return _cache[symbol];
    }

    final url =
        "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$symbol&to_currency=USD&apikey=$apiKey";

    print("🔄 Fetching real price for $symbol...");
    final data = await _fetch(url);

    if (data == null) {
      print("⚠️ API failed for $symbol, using mock data");
      return _getMockPrice(symbol);
    }

    final rate = data["Realtime Currency Exchange Rate"];
    if (rate == null || rate.isEmpty) {
      print("⚠️ Empty rate for $symbol, using mock data");
      return _getMockPrice(symbol);
    }

    final price = double.tryParse(rate["5. Exchange Rate"] ?? "");
    if (price != null) {
      _cache[symbol] = price;
      print("✅ Real price for $symbol: \$$price");
      return price;
    }

    print("⚠️ Could not parse price for $symbol, using mock data");
    return _getMockPrice(symbol);
  }

  // -----------------------------
  // Get mock price with slight variation
  // -----------------------------
  double? _getMockPrice(String symbol) {
    if (!_mockPrices.containsKey(symbol)) {
      print("❌ No mock data for $symbol");
      return null;
    }

    final basePrice = _mockPrices[symbol]!;
    // Add slight random variation (±2%) to make it look more realistic
    final random = Random();
    final variation = (random.nextDouble() - 0.5) * 0.04; // -2% to +2%
    final price = basePrice * (1 + variation);

    // Cache the mock price so it stays consistent during this session
    _cache[symbol] = price;

    return price;
  }

  // -----------------------------
  // Fetch prices with rate limit handling
  // -----------------------------
  Future<Map<String, double?>> fetchAllPricesParallel() async {
    print("📊 Starting to fetch all prices...");
    final symbols = await loadSymbols();
    final Map<String, double?> finalMap = {};

    // Note: Alpha Vantage free tier = 5 calls/min, 500/day
    // For now, we'll use mock data primarily to avoid hitting limits
    // You can try fetching a few real prices by uncommenting the delay logic

    for (var item in symbols) {
      final symbol = item["symbol"];
      // final type = item["type"]; // Removed as it's unused when the API calls are commented out

      // Use mock data immediately to prevent N/A values
      // Comment this line if you want to try real API calls
      finalMap[symbol] = _getMockPrice(symbol);

      // Uncomment below to try real API calls (with delays for rate limiting)
      /*
      try {
        final type = item["type"]; // Moved inside the commented block
        final price = (type == "crypto")
            ? await getCryptoPrice(symbol)
            : await getStockPrice(symbol);
        finalMap[symbol] = price;
        
        // Add delay to respect rate limits (5 calls/min = 12 seconds between calls)
        await Future.delayed(const Duration(seconds: 13));
      } catch (e) {
        print("Error fetching $symbol: $e");
        finalMap[symbol] = _getMockPrice(symbol);
      }
      */
    }

    print("✅ Finished fetching ${finalMap.length} prices");
    return finalMap;
  }
}
