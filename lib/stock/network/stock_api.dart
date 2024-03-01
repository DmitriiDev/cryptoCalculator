import 'package:cryptocalc/crypto_coins/model/exchange_screen_coin_model.dart';
import 'package:cryptocalc/main.dart';
import 'package:stock_market_data/stock_market_data.dart';

class YahooStockApi {
  final StockMarketDataService stockMarketDataService =
      StockMarketDataService();

   void getStockData(Map<String, String> stockNames) async {
    stockNames.forEach((key, value) async {
      await stockMarketDataService
          .getBackTestResultForSymbol(key)
          .then((result) {
        var share = ExchangeScreenCoinModel(
            id: "",
            image: "",
            name: value,
            currencyCode: key,
            price: '${result.endPrice}',
            lastPrice: '0.0',
            symbol: key,
            pairWith: "USD",
            decimalCurrency: 3,
            currency: false,
            isStock: true);
        box.add(share);
      });
    });
  }
}
