import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/model/country_list.dart';
import 'package:flutter/material.dart';

class SearchDataModel extends ChangeNotifier {
  List<Country> currenciesList = [];
  List<Country> filteredCurrencies = [];
  List<Country> itemsForReturn = [];

  SearchDataModel() {
    for (var value in countryList) {
      currenciesList.add(value);
    }
    filteredCurrencies = currenciesList;
  }
  void setFiltredList(String search) {
    filteredCurrencies = currenciesList.where((currency) {
      return currency.name!.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }
}
