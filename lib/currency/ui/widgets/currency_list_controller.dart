import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/model/country_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyListController extends StatefulWidget {
  const CurrencyListController({super.key});

  @override
  CurrencyListControllerState createState() => CurrencyListControllerState();
}

class CurrencyListControllerState extends State<CurrencyListController> {
  final TextEditingController searchController = TextEditingController();
  final model = SearchDataModel();
  List<Country> itemsForReturn = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Currencies'),
            leading: Row(
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, itemsForReturn);
                  },
                ),
              ],
            )),
        body: ChangeNotifierProvider.value(
          value: model,
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search a Currency',
                  hintText: 'Enter a keyword',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    model.setFiltredList(value);
                  });
                },
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: model.filteredCurrencies.length,
                        itemBuilder: (BuildContext context, index) {
                          return CheckboxListTile(
                              secondary: SizedBox(
                                  height: 35,
                                  width: 45,
                                  child: Image.asset(
                                      getFlagImageAssetPath(model
                                          .filteredCurrencies[index].isoCode!),
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Container(
                                            height: width * 0.083,
                                            width: width * 0.083,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.grey.shade400,
                                                    width: 1)),
                                            child: Center(
                                              child: Text(model
                                                      .filteredCurrencies[index]
                                                      .isoCode!
                                                      .isEmpty
                                                  ? '0'
                                                  : model
                                                      .filteredCurrencies[index]
                                                      .isoCode![0]),
                                            ),
                                          ))),
                              title: Text(model
                                  .filteredCurrencies[index].currencyCode!),
                              subtitle:
                                  Text(model.filteredCurrencies[index].name!),
                              value: model.filteredCurrencies[index].isPicked,
                              onChanged: (value) {
                                setState(() {
                                  if (model
                                      .filteredCurrencies[index].isPicked) {
                                    model.filteredCurrencies[index].isPicked =
                                        false;
                                    itemsForReturn.remove(
                                        model.filteredCurrencies[index]);
                                  } else {
                                    model.filteredCurrencies[index].isPicked =
                                        true;
                                    itemsForReturn
                                        .add(model.filteredCurrencies[index]);
                                  }
                                });
                              });
                        }),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}

class SearchDataModel extends ChangeNotifier {
  List<Country> currenciesList = [];
  List<Country> filteredCurrencies = [];

  SearchDataModel() {
    countryList.forEach((value) {
      currenciesList.add(value);
    });
    filteredCurrencies = currenciesList;
  }
  void setFiltredList(String search) {
    filteredCurrencies = currenciesList.where((currency) {
      return currency.name!.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }
}

String getFlagImageAssetPath(String assetSymbol) {
  var updatedName = assetSymbol;
  if (updatedName.toLowerCase().contains('usdt')) {
    updatedName = updatedName.substring(0, updatedName.length - 4);
  }

  if (updatedName.toLowerCase().contains('usd')) {
    updatedName = updatedName.substring(0, updatedName.length - 3);
  }

  return "assets/${updatedName.toLowerCase()}.png";
}
