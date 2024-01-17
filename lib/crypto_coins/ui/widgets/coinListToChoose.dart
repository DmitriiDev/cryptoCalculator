import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_svg_image/cached_svg_image.dart';
import 'package:cryptocalc/crypto_coins/model/coinListCoinBaseModel.dart';
import 'package:cryptocalc/crypto_coins/model/coinRankModel.dart';
import 'package:cryptocalc/crypto_coins/network/coinBaseNeteworkManager.dart';
import 'package:cryptocalc/crypto_coins/network/coinRankNetworkManager.dart';
import 'package:cryptocalc/crypto_coins/ui/widgets/coinDetailScreenWidget.dart';
import 'package:flutter/material.dart';

class CoinListToChoose extends StatelessWidget {
  const CoinListToChoose({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<CryptoAsset>>(
        future: CryptoService().fetchCryptoAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else {
            List<CryptoAsset> coinList = snapshot.data!;
            return ListView.builder(
                itemCount: coinList.length,
                itemBuilder: (context, index) {
                  return 
                  ListTile(
                    // leading: ((coinList[index].url).contains(".svg"))
                    //     ? _sizedContainer(
                    //         CachedNetworkSvgImage(
                    //           url: coinList[index].url,
                    //           loadinggif: '',
                    //         ),
                    //       )
                    //     : _sizedContainer(
                    //         CachedNetworkImage(
                    //           imageUrl: coinList[index].url,
                    //           placeholder: (context, url) =>
                    //               const CircularProgressIndicator(),
                    //           errorWidget: (context, url, error) =>
                    //               const Icon(Icons.error),
                    //         ),
                    //       ),
                    title: Text(coinList[index].name),
                    subtitle: Text(coinList[index].id),
                    // onTap: () {
                    //   // Navigator.push(
                    //   //   context,
                    //   //   MaterialPageRoute(
                    //   //     builder: (context) =>
                    //   //         CoinDetailScreenWidget(coin: coinList[index]),
                    //   //   ),
                    //   // );
                    // },
                  );
                });
          }
        },
      ),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 25,
      height: 25,
      child: Center(child: child),
    );
  }
}
