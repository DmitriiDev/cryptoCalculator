import 'dart:async';
import 'package:cryptocalc/crypto_coins/model/coin_list_coin_base_model.dart';
import 'package:cryptocalc/crypto_coins/model/coin_symbol_name_model.dart';
import 'package:cryptocalc/crypto_coins/model/search_crypto_data_model.dart';
import 'package:cryptocalc/util/get_image_asset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoListController extends StatefulWidget {
  CryptoListController(
      {required this.showAppBar, super.key, required this.model});

  final bool showAppBar;
   SearchCryptoDataModel model;

  @override
  CryptoListControllerState createState() => CryptoListControllerState();
}

class CryptoListControllerState extends State<CryptoListController> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<CryptoAsset>> cryptoAssetsFuture;
  String manualAdded = '';
  bool manualSearchBlock = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: widget.showAppBar
                ? AppBar(
                    title: const Text('Crypto Assets'),
                    leading: Row(
                      children: [
                        IconButton(
                          alignment: Alignment.centerLeft,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context, widget.model.itemsForReturn);
                          },
                        ),
                      ],
                    ))
                : null,
            body: ChangeNotifierProvider.value(
              value: widget.model,
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
                        widget.model.setFiltredList(value);
                        if (widget.model.filtredList.isEmpty) {
                          manualSearchBlock = true;
                        } else {
                          manualSearchBlock = false;
                        }
                      });
                    },
                  ),
                  manualSearchBlock
                      ? _manualCoinSearchControls(
                          manualAdded, widget.model, context)
                      : Expanded(
                          child: Column(children: [
                            Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: widget.model.filtredList.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return CheckboxListTile(
                                        secondary: SizedBox(
                                            height: 35,
                                            width: 45,
                                            child: Image.asset(
                                                getFlagImageAssetPath(widget
                                                    .model
                                                    .filtredList[index]
                                                    .symbol),
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(
                                                      height: width * 0.083,
                                                      width: width * 0.083,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              width: 1)),
                                                      child: Center(
                                                        child: Text(widget
                                                                .model
                                                                .filtredList[
                                                                    index]
                                                                .symbol
                                                                .isEmpty
                                                            ? '0'
                                                            : widget
                                                                .model
                                                                .filtredList[
                                                                    index]
                                                                .symbol[0]),
                                                      ),
                                                    ))),
                                        title: Text(widget
                                            .model.filtredList[index].fullName),
                                        subtitle: Text(widget
                                            .model.filtredList[index].symbol),
                                        value: widget
                                            .model.filtredList[index].isPicked,
                                        onChanged: (value) {
                                          setState(() {
                                            if (widget.model.filtredList[index]
                                                .isPicked) {
                                              widget.model.filtredList[index]
                                                  .isPicked = false;
                                              widget.model.itemsForReturn
                                                  .remove(widget.model
                                                      .filtredList[index]);
                                            } else {
                                              widget.model.filtredList[index]
                                                  .isPicked = true;
                                              widget.model.itemsForReturn.add(
                                                  widget.model
                                                      .filtredList[index]);
                                            }
                                          });
                                        });
                                  }),
                            ),
                          ]),
                        )
                ],
              ),
            )));
  }
}

Widget _manualCoinSearchControls(
    String manualAdded, SearchCryptoDataModel model, BuildContext context) {
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
                  model.itemsForReturn.add(CoinSymbolNameModel(
                      symbol: manualAdded,
                      fullName: manualAdded,
                      isPicked: true));
                  Navigator.pop(context, model.itemsForReturn);
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