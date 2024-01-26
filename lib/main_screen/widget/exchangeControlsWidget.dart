import 'dart:developer';
import 'package:cryptocalc/currency/model/currency_to_pick_model.dart';
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
  String currencyText = "Currency";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          const Expanded(
            child: InputAmountWidget(),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
              onPressed: () {
                navigateToCurrencyList(context);
              },
              child: Text(currencyText)),
          const SizedBox(width: 16.0),
        ],
      ),
      Text('${context.watch<ExchangeModel>().getCurrencyRate}'),
    ]);
  }

  Future<void> navigateToCurrencyList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrencyListController()),
    ).then((value) async {
      currencyText = (value as List<CurrencyToPickModel>).first.name;
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

  // set firstNumber(String value) =>
  //     _exchangedAmount = double.tryParse(value) ?? 1.0;

  void toExchange(String currencyCod) async {
    final chartData = await YahooFinanceApi.fetchChartData('$currencyCod=X');
    final rate = YahooFinanceStockResponse.fromJson(chartData);

    _exchangedAmount =
        rate.chart.result.first.meta.previousClose * _inputAmount;
    // _currencyRate = rate.chart.result.first.meta.previousClose;
    _pairWith = rate.chart.result.first.meta.symbol;
    setRate(rate.chart.result.first.meta.previousClose);
    notifyListeners();
  }

  void setAmount(double amount) {
    _inputAmount = amount;
    _exchangedAmount = _currencyRate * amount;
    notifyListeners();
    print("setAmount ${_exchangedAmount}");
  }

  void setRate(double rate) {
    _currencyRate = rate;
    notifyListeners();
    print("rate ${_currencyRate}");
  }

  @override
  void dispose() {
    log('dispose Model');
    super.dispose();
  }
}
