import 'dart:developer';
import 'package:cryptocalc/currency/model/country.dart';
import 'package:cryptocalc/currency/network/currency_api.dart';
import 'package:cryptocalc/currency/model/yahoo_currency_model.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:cryptocalc/main_screen/widget/inputAmountWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExchangeControlsWidget extends StatefulWidget {
  const ExchangeControlsWidget(this.exchangeRate, {super.key});

  final double exchangeRate;

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
                          height: height * 0.05, child: const InputAmountWidget()),
                      const Text(
                        "Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 13),
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
                          "1＄ = ${context.watch<ExchangeModel>().getCurrencyRate}€",
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
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("15",
                                style: TextStyle(
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
      MaterialPageRoute(builder: (context) => const CurrencyListController()),
    ).then((value) async {
      currencyText = (value as List<Country>).first.currencyCode!;
      currencyFlag = value.first.isoCode!;
      context.read<ExchangeModel>().toExchange(currencyText);
      setState(() {});
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

  double get getCurrencyRate {
    return _currencyRate;
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

  void toExchange(String currencyCod) async {
    final chartData = await YahooFinanceApi.fetchChartData('$currencyCod=X');
    final rate = YahooFinanceStockResponse.fromJson(chartData);

    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    _pairWith = rate.chart.result.first.meta.symbol;
    setRate(rate.chart.result.first.meta.previousClose);
    notifyListeners();
  }

  void setAmount(double amount) {
    _inputAmount = amount;
    _exchangedAmount = _currencyRate * amount;
    notifyListeners();
    // print("setAmount ${_exchangedAmount}");
  }

  void setRate(double rate) {
    _currencyRate = rate;
    notifyListeners();
    // print("rate ${_currencyRate}");
  }

  @override
  void dispose() {
    log('dispose Model');
    super.dispose();
  }
}
