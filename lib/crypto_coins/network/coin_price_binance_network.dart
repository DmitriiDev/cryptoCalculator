import 'dart:convert';
import 'dart:developer';
import 'package:cryptocalc/crypto_coins/model/binance_coin_model.dart';
import 'package:http/http.dart' as http;

class CoinsPriceBinance {
  static CoinsPriceBinance? _instance;
  CoinsPriceBinance._();
  factory CoinsPriceBinance() {
    _instance ??= CoinsPriceBinance._();
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

  Future<List<SymbolPrice>> fetchCoinListFromBinance() async {
    final response = await http.get(
      Uri.parse('https://api3.binance.com/api/v3/ticker/price'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final BinanceCoins apiResponse = BinanceCoins.fromJson(data);

      var coinList = apiResponse.data
          .where((element) => element.symbol.contains("USDT"))
          .toList();
      return coinList;
    } else {
      log('Failed to load coin list: ${response.statusCode}');
      return [];
    }
  }
}
