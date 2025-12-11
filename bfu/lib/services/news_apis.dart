import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApis {
  final String apiKey = '2R2U4ZQFS2BNG70O';

  //fetch news by Ticker(Apple,Tesla,Bitcoin etc)
  Future<Map<String, dynamic>> _fetch(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        return {};
      }
      return jsonDecode(res.body);
    } catch (e) {
      print("News API error → $e");
      return {};
    }
  }

  //fetch news by topic(crypto, stock, etc)
  Future<List<dynamic>> getNewsBySymbol(String topic) async {
    final url =
        "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&topics=$topic&apikey=$apiKey";

    final data = await _fetch(url);
    if (data["feed"] == null) return [];
    return data["feed"];
  }
}
