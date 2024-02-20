import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/binance_coin_model.dart';
import 'package:http/http.dart' as http;

class CoinPriceBinance {
  static CoinPriceBinance? _instance;
  CoinPriceBinance._();
  factory CoinPriceBinance() {
    _instance ??= CoinPriceBinance._();
    return _instance!;
  }

  Future<SymbolPrice> fetchData(String symbol) async {
    print(symbol);
    final response = await http.get(Uri.parse(
        "https://api.binance.com/api/v3/ticker/price?symbol=${symbol}USDT"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      SymbolPrice priceModel = SymbolPrice.fromJson(data);
      return priceModel;
    } else {
      throw Exception('Failed to load coin price');
    }
  }
}
