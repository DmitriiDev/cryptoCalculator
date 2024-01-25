import 'package:cryptocalc/currency/model/currency_to_pick_model.dart';
import 'package:cryptocalc/currencyCode.dart';
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
  List<CurrencyToPickModel> itemsForReturn = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  width: 16,
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
                              title: Text(model.filteredCurrencies[index].name),
                              subtitle:
                                  Text(model.filteredCurrencies[index].shortName),
                              value: model.filteredCurrencies[index].isPicked,
                              onChanged: (value) {
                                setState(() {
                                  if (model.filteredCurrencies[index].isPicked) {
                                    model.filteredCurrencies[index].isPicked =
                                        false;
                                    itemsForReturn
                                        .remove(model.filteredCurrencies[index]);
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
  List<CurrencyToPickModel> currenciesList = [];
  List<CurrencyToPickModel> filteredCurrencies = [];

  SearchDataModel() {
    currencyMap.forEach((key, value) {
      currenciesList.add(
          CurrencyToPickModel(name: key, shortName: value, isPicked: false));
    });
    filteredCurrencies = currenciesList;
  }
  void setFiltredList(String search) {
    filteredCurrencies = currenciesList.where((currency) {
      return currency.name.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }
}
