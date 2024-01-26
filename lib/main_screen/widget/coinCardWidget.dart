import 'package:cryptocalc/crypto_coins/model/exchangeScreenCoinModel.dart';
import 'package:flutter/material.dart';

Widget coinCard({
  required BuildContext context,
  required ExchangeScreenCoinModel coin,
  required String pairWith,
  required double amount,
  required double rate,
  required bool type
}) {
  double oldPrice = coin.lastPrice.isEmpty
      ? double.parse(coin.price)
      : double.parse(coin.lastPrice);
  coin.lastPrice = coin.price;
  print('coin.price ${coin.price}');
  print('amount $amount');
  print('rate $rate');
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
                  Image.network(
                    coin.image,
                    height: width * 0.085,
                    width: width * 0.085,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: width * 0.083,
                      width: width * 0.083,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade400, width: 1)),
                      child: Center(
                        child: Text(coin.name.isEmpty ? '0' : coin.name[0]),
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
                        // width: width * 0.24,
                        child: Row(
                          children: [
                            Text(
                              "${coin.shortName} / ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              pairWith,
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
                width: width * 0.22,
                child: Text(
                  // coin.pairWith.toLowerCase() == 'inr'
                  //     ? (rate / (double.parse((coin.price)) * amount))
                  //         .toStringAsFixed(coin.decimalCurrency)
                  //     : (double.parse(coin.price) * amount)
                  //         .toStringAsFixed(coin.decimalCurrency),
                  type ? ((double.parse((coin.price)) * amount) / rate)
                      .toStringAsFixed(coin.decimalCurrency) : 
                      ((double.parse((coin.price)) * amount) * rate)
                      .toStringAsFixed(coin.decimalCurrency),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: double.parse(coin.price) > oldPrice
                        ? Colors.lightGreen
                        : double.parse(coin.price) < oldPrice
                            ? Colors.red
                            : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
