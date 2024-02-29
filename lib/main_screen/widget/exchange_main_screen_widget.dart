import 'dart:async';
import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/binance_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/coin_symbol_name_model.dart';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/crypto_coins/model/search_crypto_data_model.dart';
import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/model/yahoo_currency_model.dart';
import 'package:cryptocalc/currency/network/currency_api.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:cryptocalc/main.dart';
import 'package:cryptocalc/main_screen/widget/exchange_controls_widget.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:http/http.dart' as http;
import 'package:cryptocalc/crypto_coins/ui/widgets/coin_to_pick_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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
  List<ExchangeScreenCoinModel> allCoinsList = <ExchangeScreenCoinModel>[];
  List<String> tickerList = [];
  double amount = 1.0;
  final StreamController<List<ExchangeScreenCoinModel>> _dataStreamController =
      StreamController<List<ExchangeScreenCoinModel>>();
  late List<SymbolPrice> coinList = [];
  List<ExchangeScreenCoinModel> coinsList = [];
  List<String> names = [];
  late WebSocketChannel channelHome;
  final StockMarketDataService stockMarketDataService =
      StockMarketDataService();
  final YahooFinanceService yahooFinanceServicePrices = YahooFinanceService();
  List<StockTicker>? stockTicker = [];
  Map<String, String> tickers = <String, String>{};
  List<ExchangeScreenCoinModel> stocksData = [];
  List<ExchangeScreenCoinModel> currencyData = [];
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    fetchCoinListFromBinance();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    loadData();
    subscribeToCoins(tickerList, names);
  }

  void loadData() async {
    var items = (box.values.toList().reversed.toList()
        as List<ExchangeScreenCoinModel>);
    allCoinsList.addAll(items);
    for (var i in allCoinsList) {
      if (i.currency == false && i.isStock == false) {
        tickerList.add('${i.symbol}@ticker'.toLowerCase());
      }
      names.add(i.symbol);
    }
    setState(() {
      _dataStreamController.sink.add(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: StreamBuilder<List<ExchangeScreenCoinModel>>(
        stream: _dataStreamController.stream,
        initialData: allCoinsList,
        builder: (context, snapshot) {
          return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Coin Exchange'),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: FloatingActionBubble(
                    items: <Bubble>[
                      Bubble(
                        title: "Currency",
                        iconColor: Colors.white,
                        bubbleColor: Colors.blue,
                        icon: Icons.currency_exchange,
                        titleStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        onPress: () {
                          navigateToCurrencyList(context);
                        },
                      ),
                      Bubble(
                        title: "Crypto",
                        iconColor: Colors.white,
                        bubbleColor: Colors.blue,
                        icon: Icons.currency_bitcoin_rounded,
                        titleStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        onPress: () {
                          _navigateAndDisplayCryptoCoinSelection(context);
                        },
                      ),
                      Bubble(
                        title: "Stocks",
                        iconColor: Colors.white,
                        bubbleColor: Colors.blue,
                        icon: Icons.candlestick_chart,
                        titleStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        onPress: () async {
                          stockTicker = await showSearch(
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
                                  const Icon(
                                      Icons.precision_manufacturing_outlined),
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
                            value!
                                .map((e) =>
                                    tickers[e.symbol] = e.description ?? "")
                                .toList();
                            getStockData(tickers);
                          });
                          setState(() {
                            _dataStreamController.sink.add(stocksData);
                          });
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
                  ),
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
                                      _dataStreamController.sink
                                          .add(allCoinsList);
                                      box.delete(allCoinsList[index].key);
                                      allCoinsList.removeAt(index);
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

  Future<void> fetchCoinListFromBinance() async {
    final response = await http.get(
      Uri.parse('https://api3.binance.com/api/v3/ticker/price'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final BinanceCoins apiResponse = BinanceCoins.fromJson(data);

      setState(() {
        coinList = apiResponse.data
            .where((element) => element.symbol.contains("USDT"))
            .toList();
      });
    } else {
      // print('Failed to load coin list: ${response.statusCode}');
    }
  }

  Future<void> _navigateAndDisplayCryptoCoinSelection(
      BuildContext context) async {
    channelHome.sink.close();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CryptoListController(
                  showAppBar: true,
                  model: SearchCryptoDataModel(),
                ))).then((value) async {
      tickerList = [];
      allCoinsList = [];
      var returnData = (value as List<CoinSymbolNameModel>);
      List<CoinSymbolNameModel> formateData = [];
      print(value.first.symbol);
      for (var e in returnData) {
        formateData.add(CoinSymbolNameModel(
            symbol: '${e.symbol}USDT'.toUpperCase(),
            fullName: e.fullName,
            isPicked: true));
      }

      var onlySymbols = formateData.map((e) => e.symbol).toList();
      for (var value in formateData) {
        tickerList.add('${value.symbol.toLowerCase()}@ticker');
      }

      for (var c in coinList) {
        for (var e in formateData) {
          if (c.symbol.toLowerCase() == e.symbol.toLowerCase()) {
            tickerList.add('${c.symbol.toLowerCase()}@ticker');
            var coin = ExchangeScreenCoinModel(
                id: "",
                image: "",
                name: e.fullName,
                currencyCode: e.symbol,
                price: c.price,
                lastPrice: c.price,
                symbol: c.symbol,
                pairWith: c.symbol,
                decimalCurrency: 3,
                currency: false,
                isStock: false);
            allCoinsList.add(coin);
            box.add(coin);
          }
        }
      }

      // print("tickerList ${tickerList.length}");
      // print(tickerList);
      // print("coins is ${coinList.length}");
      // print("coins is ${allCoinsList.first.name}");
      subscribeToCoins(tickerList, onlySymbols);
    });
  }

  subscribeToCoins(
      List<String> tickerList, List<String> coinsToSubscribe) async {
    allCoinsList += coinsList;
    print(names.toString());
    print(allCoinsList.toString());
    connectToServer(tickerList, coinsToSubscribe);
  }

  connectToServer(tickerList, List<String> coinNames) {
    channelHome = IOWebSocketChannel.connect(Uri.parse(
      'wss://stream.binance.com:9443/ws/stream?',
    ));
    var tickerLowCased =
        (tickerList as List<String>).map((e) => e.toLowerCase()).toList();
    var subRequestHome = {
      'method': "SUBSCRIBE",
      'params': tickerLowCased,
      'id': 1,
    };

    var jsonString = json.encode(subRequestHome);
    channelHome.sink.add(jsonString);
    var result = channelHome.stream.transform(
      StreamTransformer<dynamic, dynamic>.fromHandlers(
        handleData: (number, sink) {
          sink.add(number);
        },
      ),
    );
    result.listen((event) {
      var snapshot = jsonDecode(event);
      updateCoin(snapshot['s'].toString(), snapshot['c'].toString(),
          snapshot['P'].toString(), coinNames);
    });
  }

  void updateCoin(String coinSymbol, String coinPrice, String coinPercentage,
      List<String> names) async {
    var price = coinPrice.substring(0, coinPrice.length - 4);
    var index = allCoinsList
        .where((element) => names.contains(element.symbol.toUpperCase()))
        .toList();
        
    index.addAll(stocksData);
    index.addAll(currencyData);

    for (var i in index) {
      if (i.symbol == coinSymbol) {
        i.price = price;
      }
    }
    _dataStreamController.sink.add(index);
  }

  void getStockData(Map<String, String> stockNames) async {
    stocksData = [];
    stockNames.forEach((key, value) async {
      await stockMarketDataService
          .getBackTestResultForSymbol(key)
          .then((result) {
        var share = ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: value,
            currencyCode: key,
            price: '${result.endPrice}',
            lastPrice: '0.0',
            symbol: key,
            pairWith: "USD",
            decimalCurrency: 3,
            currency: false,
            isStock: true);
        stocksData.add(share);
        box.add(share);
        setState(() {
          _dataStreamController.sink.add(stocksData);
        });
      });
    });
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
      getCurrencyData(value);
    });
  }

  void getCurrencyData(List<Country> currencyNames) async {
    currencyData = [];
    currencyNames.forEach((value) async {
      // print(value.currencyCode);
      await YahooFinanceApi.fetchChartData('${value.currencyCode}=X')
          .then((result) {
        final rate = YahooFinanceStockResponse.fromJson(result);
        var currency = ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: value.name!,
            currencyCode: value.currencyCode!,
            price: '${rate.chart.result.first.meta.previousClose}',
            lastPrice: '0.0',
            symbol: value.isoCode!,
            pairWith: "USD",
            decimalCurrency: 3,
            currency: true,
            isStock: false);
        currencyData.add(currency);
        box.add(currency);
        setState(() {
          _dataStreamController.sink.add(currencyData);
        });
      });
    });
  }
}
