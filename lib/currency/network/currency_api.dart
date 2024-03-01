import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/model/yahoo_currency_model.dart';
import 'package:cryptocalc/main.dart';
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

   static void getCurrencyData(List<Country> currencyNames) async {
    // ignore: avoid_function_literals_in_foreach_calls
    currencyNames.forEach((value) async {
      await fetchChartData('${value.currencyCode}=X')
          .then((result) {
        final rate = YahooFinanceStockResponse.fromJson(result);
        var currency = ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: value.name!,
            currencyCode: value.currencyCode!,
            price: '${rate.chart.result.first.meta.previousClose}',
            lastPrice: '0.0',
            symbol: value.isoCode!,
            pairWith: "USD",
            decimalCurrency: 3,
            currency: true,
            isStock: false);
        box.add(currency);
      });
    });
  }

}
