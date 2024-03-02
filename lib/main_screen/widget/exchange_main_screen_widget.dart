import 'dart:async';
import 'package:cryptocalc/crypto_coins/model/binance_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/search_crypto_data_model.dart';
import 'package:cryptocalc/crypto_coins/network/binance_web_socket_network.dart';
import 'package:cryptocalc/crypto_coins/network/coin_price_binance_network.dart';
import 'package:cryptocalc/currency/network/currency_api.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:cryptocalc/main.dart';
import 'package:cryptocalc/main_screen/widget/exchange_controls_widget.dart';
import 'package:cryptocalc/stock/network/stock_api.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coin_to_pick_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';
import '../../currency/model/search_data_model.dart';
import 'coin_card_widget.dart';

class ExchangFullScreenWidget extends StatefulWidget {
  const ExchangFullScreenWidget({super.key});

  @override
  State<ExchangFullScreenWidget> createState() =>
      _ExchangFullScreenWidgetState();
}

class _ExchangFullScreenWidgetState extends State<ExchangFullScreenWidget>
    with SingleTickerProviderStateMixin {
  final model = ExchangeModel();
  List<String> tickerList = [];
  late List<SymbolPrice> coinList = [];
  List<ExchangeScreenCoinModel> coinsList = [];
  List<String> names = [];
  final YahooStockApi stockMarketDataService = YahooStockApi();
  List<StockTicker>? stockTicker = [];
  Map<String, String> tickers = <String, String>{};
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    BinanceWebSocketNetwork();
    loadData(true);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
          return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Coin Exchange'),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: floatinActionButton(),
                  body: Center(
                      child: SizedBox(
                    child: Column(children: [
                      ExchangeControlsWidget(model.getCurrencyRate,
                          amountOfAssets: snapshot.data!.length),
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
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    setState(() {
                                      box.delete(
                                          model.getAllCoinsList[index].key);
                                      model.getAllCoinsList.removeAt(index);
                                      model
                                          .setCoinStream(model.getAllCoinsList);
                                    });
                                  },
                                  child: coinCard(
                                      context: context2,
                                      coin: snapshot.data![index],
                                      amount: model.getAmountFromInput,
                                      pairWith: context
                                          .watch<ExchangeModel>()
                                          .getpairWith,
                                      rate: model.getCurrencyRate,
                                      type: snapshot.data![index].currency,
                                      isCryptoExchange: context
                                          .watch<ExchangeModel>()
                                          .isToCrypto,
                                      currenycCode: snapshot
                                          .data![index].currencyCode
                                          .toUpperCase()));
                            }),
                      ),
                    ]),
                  ))));
        },
      ),
    );
  }

  Widget floatinActionButton() {
    return FloatingActionBubble(
      items: <Bubble>[
        Bubble(
          title: "Currency",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.currency_exchange,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            navigateToCurrencyList(context);
          },
        ),
        Bubble(
          title: "Crypto",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.currency_bitcoin_rounded,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            _navigateAndDisplayCryptoCoinSelection(context);
          },
        ),
        Bubble(
          title: "Stocks",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.candlestick_chart,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            _searchStock();
          },
        ),
      ],
      animation: _animation,
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: Colors.blue,
      iconData: Icons.add,
      backGroundColor: Colors.white,
    );
  }

  Future<void> _searchStock() {
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
      ),
    ).then((value) {
      value!.map((e) => tickers[e.symbol] = e.description ?? "").toList();
      stockMarketDataService.getStockData(tickers);
      loadData(false);
      return null;
    });
  }

  Future<void> _navigateAndDisplayCryptoCoinSelection(
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
}
