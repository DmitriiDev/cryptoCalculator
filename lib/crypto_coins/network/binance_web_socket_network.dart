import 'dart:async';
import 'dart:convert';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/main.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../main_screen/widget/exchange_controls_widget.dart';
import '../model/binance_coin_model.dart';
import '../model/coin_symbol_name_model.dart';

class BinanceWebSocketNetwork {

   static WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse(
      'wss://stream.binance.com:9443/ws/stream?',
    ));

  connectToServer(tickerList,
      List<ExchangeScreenCoinModel> allCoinsList, ExchangeModel model) {
    channelHome.sink.close();
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
          allCoinsList, model);
    });
  }

  void updateCoin(String coinSymbol, String coinPrice, 
      List<ExchangeScreenCoinModel> allCoinsList, ExchangeModel model) async {
    var price = coinPrice.substring(0, coinPrice.length - 4);
    for (var i in model.getAllCoinsList) {
      if (i.symbol == coinSymbol) {
        i.price = price;
      }
    }
    model.setCoinStream(model.getAllCoinsList);
  }

    void getCoinToSubscribe(
      List<SymbolPrice> coinList, List<CoinSymbolNameModel> coinsToSubscribe) async {
  
      List<CoinSymbolNameModel> formateData = [];
      for (var e in coinsToSubscribe) {
        formateData.add(CoinSymbolNameModel(
            symbol: '${e.symbol}USDT'.toUpperCase(),
            fullName: e.fullName,
            isPicked: true));
      }
      for (var c in coinList) {
        for (var e in formateData) {
          if (c.symbol.toLowerCase() == e.symbol.toLowerCase()) {
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
            box.add(coin);
          }
        }
      }
  }

}
