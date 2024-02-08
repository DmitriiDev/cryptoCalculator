import 'dart:async';
import 'package:cryptocalc/crypto_coins/model/coinListCoinBaseModel.dart';
import 'package:cryptocalc/crypto_coins/model/coin_symbol_name_model.dart';
import 'package:cryptocalc/crypto_coins/network/list_crypto.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoListController extends StatefulWidget {
  const CryptoListController({super.key});

  @override
  CryptoListControllerState createState() => CryptoListControllerState();
}

class CryptoListControllerState extends State<CryptoListController> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<CryptoAsset>> cryptoAssetsFuture;

  final model = SearchDataModel();
  List<CoinSymbolNameModel> itemsForReturn = [];
  String manualAdded = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: const Text('Crypto Assets'),
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
                decoration: const InputDecoration(
                  labelText: 'Add Manualy Crypto',
                  hintText: 'Enter a code name of Crypto',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  manualAdded = value;
                },
              ),
              ElevatedButton(
                  onPressed: () =>
                      itemsForReturn.add(CoinSymbolNameModel(symbol: manualAdded, fullName: manualAdded, isPicked: true))
                      ,
                  child: const Text("ADD")),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Crypto Assets',
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
                        itemCount: model.filtredList.length,
                        itemBuilder: (BuildContext context, index) {
                          return CheckboxListTile(
                              secondary: SizedBox(
                                  height: 35,
                                  width: 45,
                                  child: Image.asset(
                                      getFlagImageAssetPath(model
                                          .filtredList[index].symbol),
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
                                                      .filtredList[index]
                                                      .symbol
                                                      .isEmpty
                                                  ? '0'
                                                  : model
                                                      .filtredList[index]
                                                      .symbol[0]),
                                            ),
                                          ))),
                              title: Text(model
                                  .filtredList[index].fullName),
                              subtitle:
                                  Text(model.filtredList[index].symbol),
                              value: model.filtredList[index].isPicked,
                              onChanged: (value) {
                                setState(() {
                                  if (model
                                      .filtredList[index].isPicked) {
                                    model.filtredList[index].isPicked =
                                        false;
                                    itemsForReturn.remove(
                                        model.filtredList[index]);
                                  } else {
                                    model.filtredList[index].isPicked =
                                        true;
                                    itemsForReturn
                                        .add(model.filtredList[index]);
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
  List<CoinSymbolNameModel> allNamesInitData = [];
  List<CoinSymbolNameModel> filtredList = [];
  SearchDataModel() {
    cryptoNetworksMap.forEach((key, value) {
      allNamesInitData.add(CoinSymbolNameModel(symbol: key, fullName: value, isPicked: false));
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
