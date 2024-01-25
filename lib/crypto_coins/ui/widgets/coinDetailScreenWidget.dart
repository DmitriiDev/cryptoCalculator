import 'package:cryptocalc/crypto_coins/model/coinRankModel.dart';
import 'package:flutter/material.dart';

class CoinDetailScreenWidget extends StatelessWidget {
  final CoinRankModel coin;

  const CoinDetailScreenWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Symbol: ${coin.symbol}'),
            Text('Market Cap: ${coin.marketCap}'),
            Text('Price: ${coin.price}'),
          ],
        ),
      ),
    );
  }
}
