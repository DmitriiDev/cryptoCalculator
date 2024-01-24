import 'dart:convert';
import 'package:cryptocalc/currency/yahooCurrencyModel.dart';
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

void main() async {
  try {
    final chartData = await YahooFinanceApi.fetchChartData('NZD=X');
    final ff = YahooFinanceResponse.fromJson(chartData);
    print(ff.chart.result.first.meta.previousClose);
    // Process the chart data here
  } catch (e) {
    print('Error: $e');
  }
}
