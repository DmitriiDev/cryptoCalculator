import 'dart:developer';
import 'package:cryptocalc/currency/currencyApi.dart';
import 'package:cryptocalc/currency/yahooCurrencyModel.dart';
import 'package:cryptocalc/currencyCode.dart';
import 'package:cryptocalc/main_screen/widget/inputAmountWidget.dart';
import 'package:flutter/material.dart';
import 'package:live_currency_rate/live_currency_rate.dart';
import 'package:provider/provider.dart';

class ExchangeControlsWidget extends StatefulWidget {
  const ExchangeControlsWidget(this.exchangeRate, {super.key});

  final double exchangeRate;

  @override
  ExchangeControlState createState() => ExchangeControlState();
}

class ExchangeControlState extends State<ExchangeControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          ElevatedButton(
              onPressed: () {
                context.read<ExchangeModel>().toEur();
              },
              child: const Text("EUR")),
          ElevatedButton(
              onPressed: () {
                context.read<ExchangeModel>().toUsd();
              },
              child: const Text("USD")),
          ElevatedButton(
              onPressed: () {
                context.read<ExchangeModel>().toTry();
              },
              child: const Text("TRY")),
          ElevatedButton(
              onPressed: () {
                context.read<ExchangeModel>().toChilPeso();
              },
              child: Text(CurrencyCode.chileanPeso)),
        ],
      ),
      Text('${context.read<ExchangeModel>().getCurrencyRate}'),
      const InputAmountWidget(),
    ]);
  }
}

class ExchangeModel extends ChangeNotifier {
  ExchangeModel() {
    log('constructor Model');
  }
  double _exchangedAmount = 1.0;
  double _inputAmount = 1.0;
  String _pairWith = '';
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

  set firstNumber(String value) =>
      _exchangedAmount = double.tryParse(value) ?? 1.0;

  void toEur() async {
    final chartData = await YahooFinanceApi.fetchChartData('EUR=X');
    final rate = YahooFinanceResponse.fromJson(chartData);

    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    _currencyRate = rate.chart.result.first.meta.previousClose;
    _pairWith = "EUR";
    print("toEur");
    notifyListeners();
  }

  void toUsd() async {
    CurrencyRate rate = await LiveCurrencyRate.convertCurrency(
        CurrencyCode.dollarUSA, CurrencyCode.dollarUSA, 1);
    print("rate.result:${rate.result} and _inputAmount:${_inputAmount}");
    _exchangedAmount = rate.result * _inputAmount;
    _currencyRate = rate.result;
    _pairWith = "USD";
    notifyListeners();
  }

  void toTry() async {

    final chartData = await YahooFinanceApi.fetchChartData('TRY=X');
    final rate = YahooFinanceResponse.fromJson(chartData);

    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    _currencyRate = rate.chart.result.first.meta.previousClose;
    _pairWith = CurrencyCode.turkishLira;
    notifyListeners();
  }

  void toChilPeso() async {
    final chartData = await YahooFinanceApi.fetchChartData('CLP=X');
    final rate = YahooFinanceResponse.fromJson(chartData);
    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    _currencyRate = rate.chart.result.first.meta.previousClose;
    _pairWith = CurrencyCode.chileanPeso;
    notifyListeners();
  }

  void setAmount(double amount) {
    _inputAmount = amount;
    _exchangedAmount = _currencyRate * amount;
    notifyListeners();
    print("setAmount ${_exchangedAmount}");
  }

  @override
  void dispose() {
    log('dispose Model');
    super.dispose();
  }
}
