import 'dart:async';
import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/binanceCoinModel.dart';
import 'package:cryptocalc/crypto_coins/model/exchangeScreenCoinModel.dart';
import 'package:cryptocalc/main_screen/widget/exchangeControlsWidget.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coinController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<ExchangeScreenCoinModel> wishlistCoinsList = <ExchangeScreenCoinModel>[];
  List<String> tickerList = [];
  double amount = 1.0;
  final StreamController<List<ExchangeScreenCoinModel>> _dataStreamController =
      StreamController<List<ExchangeScreenCoinModel>>();
  late List<SymbolPrice> coinList = [];
  List<ExchangeScreenCoinModel> coinsList = [];
  List<String> names = ["BTCUSDT", "ETHUSDT"];
  late WebSocketChannel channelHome;

  @override
  void initState() {
    fetchCoinListFromBinance();
    super.initState();
    subscribeToCoins(tickerList, names);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExchangeScreenCoinModel>>(
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
                  child: ChangeNotifierProvider.value(
                    value: model,
                    child: Column(children: [
                      ExchangeControlsWidget(model.getCurrencyRate),
                      ElevatedButton(
                          onPressed: () {
                            _navigateAndDisplaySelection(context);
                          },
                          child: const Text("Coins")),
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
                                pairWith: model.getpairWith,
                              );
                            }),
                      ),
                    ]),
                  ),
                ))));
      },
    );
  }

  int comparePrices(String priceA, String priceB) {
    double a = double.parse(priceA);
    double b = double.parse(priceB);
    return a.compareTo(b);
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dispose();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CryptoListController()),
    ).then((value) {
      print(coinList.first.symbol);
      coinList = coinList
          .where((element) => (value as List<String>).contains(element.symbol))
          .toList();
      print(coinList.first.symbol);
      for (var c in coinList) {
        tickerList = [];
        allCoinsList = [];
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
      // Handle error
      print('Failed to load coin list: ${response.statusCode}');
    }
  }

  connectToServer(tickerList, List<String> coinNames) {
    channelHome = IOWebSocketChannel.connect(Uri.parse(
      'wss://stream.binance.com:9443/ws/stream?',
    ));
    print("connectToServer");
    var subRequestHome = {
      'method': "SUBSCRIBE",
      'params': tickerList,
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

  subscribeToCoins(List<String> tickerList, List<String> coinsToSubscribe) async {
    allCoinsList = coinsList;
    connectToServer(tickerList, coinsToSubscribe);
  }

  void dispose() {
    print("dd");
    channelHome.sink.close();
  }

  var selectedCurrency = '';
  List<Coin> selectedCurrencyCoins = <Coin>[];

  void updateCoin(String coinSymbol, String coinPrice, String coinPercentage,
      List<String> names) async {

    var index = allCoinsList
        .where((element) => names.contains(element.symbol.toUpperCase()))
        .toList();


    setState(() {
      // print(names);
      print("updateCoins ${index.length}");
      _dataStreamController.sink.add(index);
    });
  }
}

// List<String> tickerList = [
//   "btcusdt@ticker",
//   "ethusdt@ticker",
//   "winusdt@ticker",
//   "dentusdt@ticker",
//   "xrpusdt@ticker",
//   "etcusdt@ticker",
//   "dogeusdt@ticker",
//   "bnbusdt@ticker",
//   "cakeusdt@ticker",
//   "maticusdt@ticker",
//   "trxusdt@ticker",
//   "usdcusdt@ticker",
//   "sandusdt@ticker",
//   "maticbtc@ticker",
//   "polybtc@ticker",
//   "bnbbtc@ticker",
//   "xrpeth@ticker",
//   "shibusdt@ticker",
//   "avaxusdt@ticker",
// ];
