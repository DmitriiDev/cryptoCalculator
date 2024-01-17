class ExchangeScreenCoinModel {
  String id;
  String image;
  String name;
  String shortName;
  String price;
  String lastPrice;
  String percentage;
  String symbol;
  String pairWith;
  String highDay;
  String lowDay;
  int decimalCurrency;

  ExchangeScreenCoinModel({
    required this.id,
    required this.image,
    required this.name,
    required this.shortName,
    required this.price,
    required this.lastPrice,
    required this.percentage,
    required this.symbol,
    required this.pairWith,
    required this.highDay,
    required this.lowDay,
    required this.decimalCurrency,
  });

  @override
  String toString() {
    return 'Coin{coinID: $id, coinImage: $image, coinName: $name, coinShortName: $shortName, coinPrice: $price, coinLastPrice: $lastPrice, coinPercentage: $percentage, coinSymbol: $symbol, coinPairWith: $pairWith, coinHighDay: $highDay, coinLowDay: $lowDay, coinDecimalCurrency: $decimalCurrency}';
  }
}
