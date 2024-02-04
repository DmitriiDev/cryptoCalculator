import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/coinListCoinBaseModel.dart';
import 'package:http/http.dart' as http;

class CryptoService {
  static CryptoService? _instance;
  CryptoService._();
  factory CryptoService() {
    _instance ??= CryptoService._();
    return _instance!;
  }

  Future<List<CryptoAsset>> fetchCryptoAssets() async {
    final response =
        await http.get(Uri.parse('https://api.pro.coinbase.com/currencies'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<CryptoAsset> cryptoAssets =
          jsonData.map((asset) => CryptoAsset.fromJson(asset)).toList();
      // cryptoAssets
      //     .sort((a, b) => a.details.networkConfirmations ?? 0.compareTo(b.details.networkConfirmations ?? 0));
      return cryptoAssets;
    } else {
      throw Exception('Failed to load crypto assets');
    }
  }
}
