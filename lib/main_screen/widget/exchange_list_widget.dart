import 'dart:async';
import 'package:cryptocalc/crypto_coins/model/binance_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/search_crypto_data_model.dart';
import 'package:cryptocalc/crypto_coins/network/binance_web_socket_network.dart';
import 'package:cryptocalc/crypto_coins/network/coin_price_binance_network.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coin_to_pick_controller.dart';
import 'package:cryptocalc/currency/network/currency_api.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:cryptocalc/main.dart';
import 'package:cryptocalc/main_screen/widget/coin_card_widget.dart';
import 'package:cryptocalc/main_screen/widget/exchange_controls_widget.dart';
import 'package:cryptocalc/stock/network/stock_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';

import '../../currency/model/search_data_model.dart';

class ExchaneListWidget extends StatefulWidget {
  final bool isConvertor;
  final Function(void Function(BuildContext context))? navigateToCurrencyListCallback;

  const ExchaneListWidget(
      {super.key,
      required this.isConvertor,
       this.navigateToCurrencyListCallback});

  @override
  State<ExchaneListWidget> createState() => _ExchaneListWidgetState();
}

class _ExchaneListWidgetState extends State<ExchaneListWidget>
    with SingleTickerProviderStateMixin {
  final model = ExchangeModel();
  List<String> tickerList = [];
  late List<SymbolPrice> coinList = [];
  List<ExchangeScreenCoinModel> coinsList = [];
  List<String> names = [];
  final YahooStockApi stockMarketDataService = YahooStockApi();
  List<StockTicker>? stockTicker = [];
  Map<String, String> tickers = <String, String>{};
  late Timer timer;

  @override
  void initState() {
    super.initState();
    BinanceWebSocketNetwork();
        if (widget.navigateToCurrencyListCallback != null) {
      widget.navigateToCurrencyListCallback!(showFullWidthMenu);
    }
    loadData(true);
    timer = Timer.periodic(const Duration(seconds: 120), (Timer t) {
      updateData();
    });
  }

  void loadData(bool isCrypto) async {
    tickerList = [];
    names = [];
    stockTicker = [];
    tickers = <String, String>{};

    coinList = await CoinsPriceBinance().fetchCoinListFromBinance();

    var items = (box.values.toList().reversed.toList()
        as List<ExchangeScreenCoinModel>);
    model.clearCoinListForStream();
    model.getAllCoinsList.addAll(items);
    for (var i in model.getAllCoinsList) {
      if (i.currency == false && i.isStock == false) {
        tickerList.add('${i.symbol}@ticker'.toLowerCase());
      }
    }
    setState(() {
      model.setCoinStream(items);
    });
    if (isCrypto) {
      BinanceWebSocketNetwork()
          .connectToServer(tickerList, model.getAllCoinsList, model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: StreamBuilder<List<ExchangeScreenCoinModel>>(
        stream: model.getStreamCoins.stream,
        initialData: model.getAllCoinsList,
        builder: (context, snapshot) {
          return Center(
              child: SizedBox(
            child: Column(children: [
              widget.isConvertor == true
                  ? ExchangeControlsWidget(
                      model.getCurrencyRate,
                      amountOfAssets: snapshot.data!.length,
                      model: model,
                    )
                  : Container(),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context2, index) {
                      return Dismissible(
                          key: Key(snapshot.data![index].symbol),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              box.delete(model.getAllCoinsList[index].key);
                              model.getAllCoinsList.removeAt(index);
                              model.setCoinStream(model.getAllCoinsList);
                            });
                          },
                          child: coinCard(
                              context: context2,
                              coin: snapshot.data![index],
                              amount: model.getAmountFromInput,
                              pairWith:
                                  context.watch<ExchangeModel>().getpairWith,
                              rate: model.getCurrencyRate,
                              type: snapshot.data![index].currency,
                              isCryptoExchange:
                                  context.watch<ExchangeModel>().isToCrypto,
                              currenycCode: snapshot.data![index].currencyCode
                                  .toUpperCase(),
                              isConvertor: widget.isConvertor));
                    }),
              ),
            ]),
          ));
        },
      ),
    );
  }

  void updateData() {
    List<ExchangeScreenCoinModel> currency = [];
    List<ExchangeScreenCoinModel> stock = [];

    for (var i in model.getAllCoinsList) {
      if (i.isStock == true) {
        stock.add(i);
      }

      if (i.currency == true) {
        currency.add(i);
      }
    }
    YahooFinanceApi.updateCurrencyData(currency);
    stockMarketDataService.updateStockData(stock);
    loadData(false);
  }

  Future<void> navigateToCurrencyList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CurrencyListController(
                showAppBar: true,
                model: SearchDataModel(),
              )),
    ).then((value) {
      YahooFinanceApi.getCurrencyData(value);
      loadData(false);
    });
  }

  Future<void> navigateAndDisplayCryptoCoinSelection(
      BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CryptoListController(
                  showAppBar: true,
                  model: SearchCryptoDataModel(),
                ))).then((value) async {
      BinanceWebSocketNetwork().getCoinToSubscribe(coinList, value);
    });
    loadData(true);
  }

  void showFullWidthMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.currency_bitcoin_rounded),
                title: const Text('Crypto'),
                onTap: () {
                  navigateAndDisplayCryptoCoinSelection(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Currency'),
                onTap: () {
                  navigateToCurrencyList(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.candlestick_chart),
                title: const Text('Stocks'),
                onTap: () {
                  navigagteToStockSearch();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> navigagteToStockSearch() {
    return showSearch(
      context: context,
      delegate: TickerSearch(
        searchFieldLabel: 'Search ticker',
        suggestions: [
          TickerSuggestion(
            const Icon(Icons.view_headline),
            'Main',
            TickersList.main,
          ),
          TickerSuggestion(
            const Icon(Icons.business_sharp),
            'Companies',
            TickersList.companies,
          ),
          TickerSuggestion(
            const Icon(Icons.precision_manufacturing_outlined),
            'Sectors',
            TickersList.sectors,
          ),
          TickerSuggestion(
            const Icon(Icons.workspaces_outline),
            'Futures',
            TickersList.futures,
          ),
          TickerSuggestion(
            const Icon(Icons.account_balance_outlined),
            'Bonds',
            TickersList.bonds,
          ),
        ],
        addAllButton: null,
      ),
    ).then((value) {
      value!.map((e) => tickers[e.symbol] = e.description ?? "").toList();
      stockMarketDataService.getStockData(tickers);
      loadData(false);
      return null;
    });
  }
}
