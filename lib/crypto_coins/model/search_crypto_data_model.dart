import 'package:cryptocalc/crypto_coins/model/coin_symbol_name_model.dart';
import 'package:cryptocalc/crypto_coins/network/list_crypto.dart';
import 'package:flutter/material.dart';

class SearchCryptoDataModel extends ChangeNotifier {
  List<CoinSymbolNameModel> allNamesInitData = [];
  List<CoinSymbolNameModel> filtredList = [];
  List<CoinSymbolNameModel> itemsForReturn = [];
  SearchCryptoDataModel() {
    cryptoNetworksMap.forEach((key, value) {
      allNamesInitData.add(
          CoinSymbolNameModel(symbol: key, fullName: value, isPicked: false));
      filtredList = allNamesInitData;
    });
  }
  void setFiltredList(String search) {
    filtredList = allNamesInitData.where((cryptoAsset) {
      return cryptoAsset.fullName
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          cryptoAsset.symbol.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }
}
