import 'dart:async';
import 'package:cryptocalc/crypto_coins/model/coinListCoinBaseModel.dart';
import 'package:cryptocalc/crypto_coins/network/coinBaseNeteworkManager.dart';
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
  // <String : String> itemsForReturn = [];
  Map<String, String> itemsForReturn = {};
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
                    ElevatedButton(onPressed: () => {itemsForReturn['${manualAdded}USDT'] = '$manualAdded'}, child: Text("ADD")),
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
              FutureBuilder<List<CryptoAsset>>(
                future: model.cryptoAssetsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  } else {
                    List<CryptoAsset> coinList = snapshot.data!;
                    model.setNotFilterList(coinList);
                    return Expanded(
                      child: Column(children: [
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: model.filteredCryptoAssets.length,
                              itemBuilder: (BuildContext context, index) {
                                return CheckboxListTile(
                                    secondary: SizedBox(
                                        height: 35,
                                        width: 45,
                                        child: Image.asset(
                                            getFlagImageAssetPath(model
                                                .filteredCryptoAssets[index]
                                                .id),
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Container(
                                                  height: height * 0.083,
                                                  width: width * 0.083,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade400,
                                                          width: 1)),
                                                  child: Center(
                                                    child: Text(model
                                                            .filteredCryptoAssets[
                                                                index]
                                                            .name
                                                            .isEmpty
                                                        ? '0'
                                                        : model
                                                            .filteredCryptoAssets[
                                                                index]
                                                            .name[0]),
                                                  ),
                                                ))),
                                    title: Text(
                                        model.filteredCryptoAssets[index].name),
                                    subtitle: Text(
                                        model.filteredCryptoAssets[index].id),
                                    value: model
                                        .filteredCryptoAssets[index].isTracked,
                                    onChanged: (value) {
                                      setState(() {
                                        if (model.filteredCryptoAssets[index]
                                            .isTracked) {
                                          model.filteredCryptoAssets[index]
                                              .isTracked = false;
                                          itemsForReturn.remove(model
                                              .filteredCryptoAssets[index].id);
                                        } else {
                                          model.filteredCryptoAssets[index]
                                              .isTracked = true;
                                          itemsForReturn[
                                                  "${model.filteredCryptoAssets[index].id}USDT"] =
                                              model.filteredCryptoAssets[index]
                                                  .id;
                                        }
                                      });
                                    });
                              }),
                        ),
                      ]),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}

class SearchDataModel extends ChangeNotifier {
  SearchDataModel() {
    cryptoAssetsFuture = CryptoService().fetchCryptoAssets();
    cryptoAssetsFuture.then((value) => notFiltredCryptoAssets = value);
  }
  late Future<List<CryptoAsset>> cryptoAssetsFuture;
  List<CryptoAsset> filteredCryptoAssets = [];
  List<CryptoAsset> notFiltredCryptoAssets = [];

  void setNotFilterList(List<CryptoAsset> coins) {
    notFiltredCryptoAssets = coins;
    if (filteredCryptoAssets.isEmpty) {
      filteredCryptoAssets = coins;
    }
  }

  void setFiltredList(String search) {
    filteredCryptoAssets = notFiltredCryptoAssets.where((cryptoAsset) {
      return cryptoAsset.name.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }
}
