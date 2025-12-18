import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApis {
  final String apiKey = '2R2U4ZQFS2BNG70O';

  //fetch news by Ticker(Apple,Tesla,Bitcoin etc)
  Future<Map<String, dynamic>> _fetch(String url) async {
    try {
      print("📡 Fetching news from: $url");
      final res = await http.get(Uri.parse(url));
      print("📊 Status Code: ${res.statusCode}");

      if (res.statusCode != 200) {
        print("❌ API Error: Status ${res.statusCode}");
        print("Response: ${res.body}");
        return {};
      }

      final decoded = jsonDecode(res.body);
      print("✅ API Response keys: ${decoded.keys}");
      return decoded;
    } catch (e) {
      print("❌ News API error → $e");
      return {};
    }
  }

  //fetch news by topic(crypto, stock, etc)
  Future<List<dynamic>> getNewsBySymbol(String topic) async {
    final url =
        "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&topics=$topic&apikey=$apiKey";

    final data = await _fetch(url);

    // Check for feed data
    if (data["feed"] != null) {
      print(
        "✅ Successfully fetched ${data["feed"].length} news items for $topic",
      );
      return data["feed"];
    }

    // Check for API error/information message
    if (data["Information"] != null) {
      print("⚠️ API Information: ${data["Information"]}");
      print(
        "This usually means rate limit exceeded (5 API calls/min for free tier)",
      );
      return [];
    }

    // Check for other error messages
    if (data["Note"] != null) {
      print("⚠️ API Note: ${data["Note"]}");
      return [];
    }

    print("❌ Unexpected API response format");
    print("📄 Response keys: ${data.keys}");
    return [];
  }
}
