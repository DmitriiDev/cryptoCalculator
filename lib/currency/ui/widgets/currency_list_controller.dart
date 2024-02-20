import 'package:cryptocalc/currency/model/search_data_model.dart';
import 'package:cryptocalc/util/get_image_asset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyListController extends StatefulWidget {
  const CurrencyListController(
      {super.key, required this.showAppBar, required this.model});

  final bool showAppBar;
  final SearchDataModel model;

  @override
  CurrencyListControllerState createState() => CurrencyListControllerState();
}

class CurrencyListControllerState extends State<CurrencyListController> {
  final TextEditingController searchController = TextEditingController();

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
                    title: const Text('Currencies'),
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
                      labelText: 'Search a Currency',
                      hintText: 'Enter a keyword',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.model.setFiltredList(value);
                      });
                    },
                  ),
                  Expanded(
                    child: Column(children: [
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.model.filteredCurrencies.length,
                            itemBuilder: (BuildContext context, index) {
                              return CheckboxListTile(
                                  secondary: SizedBox(
                                      height: 35,
                                      width: 45,
                                      child: Image.asset(
                                          getFlagImageAssetPath(widget
                                              .model
                                              .filteredCurrencies[index]
                                              .isoCode!),
                                          errorBuilder:
                                              (context, error, stackTrace) =>
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
                                                      child: Text(widget
                                                              .model
                                                              .filteredCurrencies[
                                                                  index]
                                                              .isoCode!
                                                              .isEmpty
                                                          ? '0'
                                                          : widget
                                                              .model
                                                              .filteredCurrencies[
                                                                  index]
                                                              .isoCode![0]),
                                                    ),
                                                  ))),
                                  title: Text(widget.model
                                      .filteredCurrencies[index].currencyCode!),
                                  subtitle: Text(widget
                                      .model.filteredCurrencies[index].name!),
                                  value: widget
                                      .model.filteredCurrencies[index].isPicked,
                                  onChanged: (value) {
                                    setState(() {
                                      if (widget.model.filteredCurrencies[index]
                                          .isPicked) {
                                        widget.model.filteredCurrencies[index]
                                            .isPicked = false;
                                        widget.model.itemsForReturn.remove(
                                            widget.model
                                                .filteredCurrencies[index]);
                                      } else {
                                        widget.model.filteredCurrencies[index]
                                            .isPicked = true;
                                        widget.model.itemsForReturn.add(widget
                                            .model.filteredCurrencies[index]);
                                      }
                                    });

                                    if (widget.showAppBar == false) {
                                      Navigator.pop(
                                          context, widget.model.itemsForReturn);
                                    }
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
