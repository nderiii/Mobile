import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApis {
  final String ApiKey = '2R2U4ZQFS2BNG70O';

  Future<double?> getStockPrice(String symbol) async {
    final url =
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$ApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final quote = data['Global Quote'];
      if (quote != null) {
        return double.tryParse(quote['05. price']);
      }
    }
    return null;
  }

  Future<double?> getCryptoPrice(String symbol) async {
    final url =
        'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$symbol&to_currency=USD&apikey=$ApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final rate = data['Realtime Currency Exchange Rate'];
      if (rate != null) {
        return double.tryParse(rate['5. Exchange Rate']);
      }
    }
    return null;
  }
}
