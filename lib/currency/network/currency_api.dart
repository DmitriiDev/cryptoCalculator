import 'dart:convert';
import 'package:http/http.dart' as http;

class YahooFinanceApi {
  static Future<Map<String, dynamic>> fetchChartData(String symbol) async {
    final response = await http.get(
      Uri.parse('https://query2.finance.yahoo.com/v8/finance/chart/$symbol'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chart data');
    }
  }
}
