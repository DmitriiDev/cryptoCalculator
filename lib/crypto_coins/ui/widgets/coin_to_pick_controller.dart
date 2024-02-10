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
  bool manualSearchBlock = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Crypto Assets',
                  hintText: 'Enter a keyword',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    model.setFiltredList(value);
                    if (model.filtredList.isEmpty) {
                      manualSearchBlock = true;
                    } else {
                      manualSearchBlock = false;
                    }
                  });
                },
              ),
              manualSearchBlock
                  ? _manualCoinSearchControls(manualAdded, itemsForReturn, context)
                  : Expanded(
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
                                                          color: Colors
                                                              .grey.shade400,
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
                                    title:
                                        Text(model.filtredList[index].fullName),
                                    subtitle:
                                        Text(model.filtredList[index].symbol),
                                    value: model.filtredList[index].isPicked,
                                    onChanged: (value) {
                                      setState(() {
                                        if (model.filtredList[index].isPicked) {
                                          model.filtredList[index].isPicked =
                                              false;
                                          itemsForReturn
                                              .remove(model.filtredList[index]);
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

Widget _manualCoinSearchControls(
    String manualAdded, List<CoinSymbolNameModel> itemsForReturn, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(14.0),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "No coins found",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. open binance.com"),
            Text("2. find listed coins"),
            Text("3. type coin's symbol manualy below"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'Add Manualy Coin',
                    hintText: 'For example: LDO',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  manualAdded = value;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  itemsForReturn.add(CoinSymbolNameModel(
                      symbol: manualAdded,
                      fullName: manualAdded,
                      isPicked: true));
                                          Navigator.pop(context, itemsForReturn);
                },
                child: const Text("ADD")),
          ],
        ),
        SizedBox(
            width: 200,
            height: 300,
            child: Image.asset(getFlagImageAssetPath("explainhowtoget"))),
      ],
    ),
  );
}

class SearchDataModel extends ChangeNotifier {
  List<CoinSymbolNameModel> allNamesInitData = [];
  List<CoinSymbolNameModel> filtredList = [];
  SearchDataModel() {
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
