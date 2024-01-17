import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/coinRankModel.dart';
import 'package:http/http.dart' as http;

class CoinRankResponseApi {
  CoinRankApiData data;

  CoinRankResponseApi({required this.data});

  factory CoinRankResponseApi.fromJson(Map<String, dynamic> json) {
    return CoinRankResponseApi(data: CoinRankApiData.fromJson(json['data']));
  }
}

class CoinRankApiData {
  List<CoinRankModel> coins;

  CoinRankApiData({required this.coins});

  factory CoinRankApiData.fromJson(Map<String, dynamic> json) {
    List<CoinRankModel> coinList = (json['coins'] as List)
        .map((coin) => CoinRankModel.fromJson(coin))
        .toList();
    return CoinRankApiData(coins: coinList);
  }
}

class FetchCoinRankingCoins {
  static FetchCoinRankingCoins? _instance;

  FetchCoinRankingCoins._();

  factory FetchCoinRankingCoins() {
    _instance ??= FetchCoinRankingCoins._();
    return _instance!;
  }

  Future<CoinRankResponseApi> fetchCoinList() async {
    final response = await http
        .get(Uri.parse('https://api.coinranking.com/v2/coins'), headers: {
      'Content-Type':
          'coinranking2d8f28fe551d201f3df674d731d7e93f0bd88d098f564d9d',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final CoinRankResponseApi apiResponse =
          CoinRankResponseApi.fromJson(data);
      return apiResponse;
    } else {
      throw Exception('Failed to load coin list');
    }
  }
}
