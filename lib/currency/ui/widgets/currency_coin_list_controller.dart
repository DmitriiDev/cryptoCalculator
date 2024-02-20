import 'package:cryptocalc/crypto_coins/model/search_crypto_data_model.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coin_to_pick_controller.dart';
import 'package:cryptocalc/currency/model/search_data_model.dart';
import 'package:cryptocalc/currency/ui/widgets/currency_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConvertorAsset { crypto, currency }

class CryptoCurrencyConvertorPicker extends StatefulWidget {
  const CryptoCurrencyConvertorPicker({super.key});

  @override
  State<CryptoCurrencyConvertorPicker> createState() =>
      _CryptoCurrencyConvertorPickerState();
}

class _CryptoCurrencyConvertorPickerState
    extends State<CryptoCurrencyConvertorPicker> {
  ConvertorAsset _selectedSegment = ConvertorAsset.currency;
  final model = SearchDataModel();
  final modelCrypto = SearchCryptoDataModel();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            alignment: Alignment.topLeft,
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context, [model.itemsForReturn, modelCrypto.itemsForReturn]);
            },
          ),
          middle: CupertinoSlidingSegmentedControl<ConvertorAsset>(
            backgroundColor: CupertinoColors.systemGrey2,
            thumbColor: const Color.fromARGB(255, 2, 154, 255),
            groupValue: _selectedSegment,
            onValueChanged: (ConvertorAsset? value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
            children: const <ConvertorAsset, Widget>{
              ConvertorAsset.currency: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Currency',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              ConvertorAsset.crypto: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Crypto',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            },
          ),
        ),
        child: _selectedSegment == ConvertorAsset.crypto
            ? CryptoListController(
                showAppBar: false,
                model: modelCrypto,
              )
            : CurrencyListController(
                showAppBar: false,
                model: model,
              ));
  }
}
