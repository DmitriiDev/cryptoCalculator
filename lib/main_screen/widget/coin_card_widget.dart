import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/currency/model/currency_symbol.dart';
import 'package:cryptocalc/util/get_image_asset.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

Widget coinCard(
    {required BuildContext context,
    required ExchangeScreenCoinModel coin,
    required String pairWith,
    required double amount,
    required double rate,
    required bool type,
    required bool isCryptoExchange,
    required String currenycCode}) {
  double oldPrice = coin.lastPrice.isEmpty
      ? double.parse(coin.price)
      : double.parse(coin.lastPrice);
  coin.lastPrice = coin.price;
  String pairText = pairWith.length == 3
      ? pairWith
      : pairWith.replaceAll("USD", "").replaceAll("=X", "");
  String assetShortName = coin.name.replaceAll("USDT", "").split(" ").first;
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return Column(
    children: [
      InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.003),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.014),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: coin.isStock
                        ? Image.asset(
                            getStockImageAssetPath(coin.symbol),
                            height: width * 0.085,
                            width: width * 0.085,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: width * 0.083,
                              width: width * 0.083,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1)),
                              child: Center(
                                child: Text(
                                    coin.name.isEmpty ? '0' : coin.name[0]),
                              ),
                            ),
                          )
                        : Image.asset(
                            getFlagImageAssetPath(coin.symbol.toLowerCase()),
                            height: width * 0.085,
                            width: width * 0.085,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: width * 0.083,
                              width: width * 0.083,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1)),
                              child: Center(
                                child: Text(
                                    coin.name.isEmpty ? '0' : coin.name[0]),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    width: width * 0.014,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Text(
                              "$assetShortName / ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              pairText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Text(
                        coin.name,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amountFormat(coin, amount, rate, type,
                              isCryptoExchange, currenycCode, pairWith),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: double.parse(coin.price) > oldPrice
                                ? Colors.lightGreen
                                : double.parse(coin.price) < oldPrice
                                    ? Colors.red
                                    : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                            rateExchange(coin, amount, rate, type,
                                isCryptoExchange, currenycCode, pairText),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

String amountFormat(ExchangeScreenCoinModel coin, double amount, double rate,
    bool type, bool isCryptoExchange, String currenycCode, String pairWith) {
  String pairText = pairWith.length == 3
      ? pairWith
      : pairWith.replaceAll("USD", "").replaceAll("=X", "");

  final CurrencyTextInputFormatter formatterCoins = CurrencyTextInputFormatter(
    decimalDigits: 3,
    symbol: currencySymbolMap[pairText] ?? "",
  );
  final CurrencyTextInputFormatter formatterCurrency =
      CurrencyTextInputFormatter(
    decimalDigits: 3,
    symbol: '${currencySymbolMap[currenycCode] ?? ""} ',
  );

  if (isCryptoExchange) {
    return formatterCoins.format(((double.parse((coin.price)) * amount) / rate)
        .toStringAsFixed(coin.decimalCurrency));
  }

  return type
      ? formatterCurrency.format(((double.parse((coin.price)) * amount) / rate)
          .toStringAsFixed(coin.decimalCurrency))
      : formatterCoins.format(((double.parse((coin.price)) * amount) * rate)
          .toStringAsFixed(coin.decimalCurrency));
}

String rateExchange(ExchangeScreenCoinModel coin, double amount, double rate,
    bool type, bool isCryptoExchange, String currenycCode, String pairWith) {
  String amountText = amountFormat(
      coin, 1, rate, type, isCryptoExchange, currenycCode, pairWith);
  String pairText = pairWith.length == 3
      ? pairWith
      : pairWith.replaceAll("USD", "").replaceAll("=X", "");
  String result = type
      ? '1 $pairText = $amountText'
      : '1 ${currenycCode.replaceAll("USDT", "")} = $amountText $pairWith';
  return result;
}
