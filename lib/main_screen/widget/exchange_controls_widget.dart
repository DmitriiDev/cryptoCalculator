import 'dart:async';
import 'dart:developer';
import 'package:cryptocalc/crypto_coins/model/coin_symbol_name_model.dart';
import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/crypto_coins/network/coin_price_binance_network.dart';
import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/network/currency_api.dart';
import 'package:cryptocalc/currency/model/yahoo_currency_model.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_coin_list_controller.dart';
import 'package:cryptocalc/main_screen/widget/input_amount_widget.dart';
import 'package:cryptocalc/util/get_image_asset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangeControlsWidget extends StatefulWidget {
  const ExchangeControlsWidget(this.exchangeRate,
      {super.key, required this.amountOfAssets});

  final double exchangeRate;
  final int amountOfAssets;

  @override
  ExchangeControlState createState() => ExchangeControlState();
}

class ExchangeControlState extends State<ExchangeControlsWidget> {
  String currencyText = "USD";
  String currencyFlag = "us";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(234, 234, 234, 236),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: height * 0.12,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Convert",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                          height: height * 0.05,
                          child: const InputAmountWidget()),
                      const Text(
                        "Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: 13),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    navigateToCurrencyList(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.12,
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 4, right: 8, left: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(234, 234, 234, 236),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "To",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: height * 0.05,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 25,
                                  height: 20,
                                  child: Image.asset(getFlagImageAssetPath(
                                      currencyFlag.toLowerCase()))),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(currencyText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                        Text(
                          "1＄ = ${context.watch<ExchangeModel>().getCurrencyRate}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  navigateToCurrencyList(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.12,
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 4, right: 8, left: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(234, 234, 234, 236),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "For",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                      SizedBox(
                        height: height * 0.05,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${widget.amountOfAssets}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                      const Text(
                        "Assets",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              // ),
            ),
          ],
        ),
      ),
    ]);
  }

  Future<void> navigateToCurrencyList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CryptoCurrencyConvertorPicker()),
    ).then((value) async {
      if (value[0].runtimeType == Country) {
        currencyText = (value).first.currencyCode!;
        currencyFlag = value.first.isoCode!;
        context.read<ExchangeModel>().toExchange(currencyText);
        setState(() {});
      } else {
        var symbol = (value[1] as List<CoinSymbolNameModel>).first.symbol;
        currencyText = symbol;
        currencyFlag = symbol;
        context.read<ExchangeModel>().toExchangeCrypto(symbol);
        setState(() {});
      }
    });
  }
}

class ExchangeModel extends ChangeNotifier {
  ExchangeModel() {
    log('constructor Model');
  }
  double _exchangedAmount = 1.0;
  double _inputAmount = 1.0;
  String _pairWith = 'USD';
  double _currencyRate = 1.0;
  double _coinPrice = 0.0;
  bool isToCrypto = false;
  final StreamController<List<ExchangeScreenCoinModel>> _dataStreamController =
      StreamController<List<ExchangeScreenCoinModel>>();
  List<ExchangeScreenCoinModel> _allCoinsList = <ExchangeScreenCoinModel>[];

  double get getCurrencyRate {
    return _currencyRate;
  }

  double get getCoinPrice {
    return _coinPrice;
  }

  String get getpairWith {
    return _pairWith;
  }

  double get getExchangedAmount {
    return _exchangedAmount;
  }

  double get getAmountFromInput {
    return _inputAmount;
  }

  StreamController<List<ExchangeScreenCoinModel>> get getStreamCoins {
    return _dataStreamController;
  }

  List<ExchangeScreenCoinModel> get getAllCoinsList {
    return _allCoinsList;
  }

  void toExchange(String currencyCode) async {
    final chartData = await YahooFinanceApi.fetchChartData('$currencyCode=X');
    final rate = YahooFinanceStockResponse.fromJson(chartData);
    isToCrypto = false;
    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    _pairWith = rate.chart.result.first.meta.symbol;
    setRate(rate.chart.result.first.meta.previousClose);
    notifyListeners();
  }

  void toExchangeCrypto(String coinSymbol) async {
    final chartData = await CoinsPriceBinance().fetchData(coinSymbol);
    _coinPrice = double.parse(chartData.price);
    _pairWith = chartData.symbol.replaceAll("USDT", "");
    isToCrypto = true;
    setRate(double.parse(chartData.price));
    notifyListeners();
  }

  void setAmount(double amount) {
    _inputAmount = amount;
    _exchangedAmount = _currencyRate * amount;
    notifyListeners();
  }

  void setRate(double rate) {
    _currencyRate = rate;
    notifyListeners();
  }

  void setCoinStream(List<ExchangeScreenCoinModel> coins) {
    _dataStreamController.sink.add(coins);
    notifyListeners();
  }

  void clearCoinListForStream() {
    _allCoinsList = [];
    notifyListeners();
  }

  @override
  void dispose() {
    log('dispose Model');
    super.dispose();
  }
}
