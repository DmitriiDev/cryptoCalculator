import 'dart:async';
import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/binanceCoinModel.dart';
import 'package:cryptocalc/crypto_coins/model/exchangeScreenCoinModel.dart';
import 'package:cryptocalc/main_screen/widget/exchangeControlsWidget.dart';
import 'package:cryptocalc/testTickerSearch.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coinController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'coinCardWidget.dart';

class ExchangFullScreenWidget extends StatefulWidget {
  const ExchangFullScreenWidget({Key? key}) : super(key: key);

  @override
  State<ExchangFullScreenWidget> createState() =>
      _ExchangFullScreenWidgetState();
}

class _ExchangFullScreenWidgetState extends State<ExchangFullScreenWidget> {
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

  @override
  void initState() {
    fetchCoinListFromBinance();
    super.initState();
    subscribeToCoins(tickerList, names);
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
                  body: Center(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(children: [
                      ExchangeControlsWidget(model.getCurrencyRate),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _navigateAndDisplaySelection(context);
                              },
                              child: const Text("Coins")),
                          ElevatedButton(
                              onPressed: () async {
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
                                        const Icon(Icons
                                            .precision_manufacturing_outlined),
                                        'Sectors',
                                        TickersList.sectors,
                                      ),
                                      TickerSuggestion(
                                        const Icon(Icons.workspaces_outline),
                                        'Futures',
                                        TickersList.futures,
                                      ),
                                      TickerSuggestion(
                                        const Icon(
                                            Icons.account_balance_outlined),
                                        'Bonds',
                                        TickersList.bonds,
                                      ),
                                    ],
                                  ),
                                ).then((value) {
                                  value!
                                      .map((e) => tickers[e.symbol] =
                                          e.description ?? "")
                                      .toList();
                                  getStockData(tickers);
                                });
                                print(tickers);

                                setState(() {
                                  _dataStreamController.sink.add(stocksData);
                                });
                              },
                              child: const Text("Stocks"))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context2, index) {
                              return coinCard(
                                context: context2,
                                coin: snapshot.data![index],
                                amount: model.getExchangedAmount,
                                pairWith:
                                    context.watch<ExchangeModel>().getpairWith,
                              );
                            }),
                      ),
                    ]),
                  ))));
        },
      ),
    );
  }

  int comparePrices(String priceA, String priceB) {
    double a = double.parse(priceA);
    double b = double.parse(priceB);
    return a.compareTo(b);
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    channelHome.sink.close();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CryptoListController()),
    ).then((value) {
      // print(coinList.first.symbol);
      tickerList = [];
      allCoinsList = [];
      for (var i in (value as List<String>)) {
        tickerList.add('${i.toLowerCase()}@ticker');
      }
      coinList = coinList
          .where((element) =>
              (value as List<String>).contains(element.symbol.toUpperCase()))
          .toList();
      // print(coinList.first.symbol);
      for (var c in coinList) {
        allCoinsList.add(ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: c.symbol,
            shortName: c.symbol,
            price: c.price,
            lastPrice: c.price,
            percentage: '0.0',
            symbol: c.symbol,
            pairWith: c.symbol,
            highDay: '',
            lowDay: '',
            decimalCurrency: 3));
      }
      print("tickerList ${tickerList.length}");
      print("value is ${value}");
      subscribeToCoins(tickerList, (value as List<String>));
    });
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
        coinList.sort((a, b) => comparePrices(
              b.price,
              a.price,
            ));
        for (var c in coinList) {
          tickerList.add('${c.symbol}@ticker');
          allCoinsList.add(ExchangeScreenCoinModel(
              id: "",
              image: "",
              name: c.symbol,
              shortName: c.symbol,
              price: c.price,
              lastPrice: c.price,
              percentage: '0.0',
              symbol: c.symbol,
              pairWith: c.symbol,
              highDay: '',
              lowDay: '',
              decimalCurrency: 3));
        }
      });
    } else {
      // print('Failed to load coin list: ${response.statusCode}');
    }
  }

  void getStockData(Map<String, String> stockNames) async {
    stockNames.forEach((key, value) async {
      await stockMarketDataService
          .getBackTestResultForSymbol(key)
          .then((result) {
        stocksData.add(ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: key,
            shortName: value,
            price: '${result.endPrice}',
            lastPrice: '0.0',
            percentage: '0.0',
            symbol: key,
            pairWith: "USDT",
            highDay: '',
            lowDay: '',
            decimalCurrency: 3));
        setState(() {
          _dataStreamController.sink.add(stocksData);
        });
      });
    });
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
      // print(snapshot);
      updateCoin(snapshot['s'].toString(), snapshot['c'].toString(),
          snapshot['P'].toString(), coinNames);
    });
  }

  subscribeToCoins(
      List<String> tickerList, List<String> coinsToSubscribe) async {
    allCoinsList = coinsList;
    connectToServer(tickerList, coinsToSubscribe);
  }

  var selectedCurrency = '';
  List<Coin> selectedCurrencyCoins = <Coin>[];

  void updateCoin(String coinSymbol, String coinPrice, String coinPercentage,
      List<String> names) async {
    var price = coinPrice.substring(0, coinPrice.length - 4);
    var index = allCoinsList
        .where((element) => names.contains(element.symbol.toUpperCase()))
        .toList();

    for (var i in index) {
      if (i.symbol == coinSymbol) {
        i.price = price;
        i.percentage = coinPercentage;
      }
    }
    _dataStreamController.sink.add(index);
  }
}
