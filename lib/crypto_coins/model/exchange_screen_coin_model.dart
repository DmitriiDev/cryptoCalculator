class ExchangeScreenCoinModel {
  String id;
  String image;
  String name;
  String price;
  String lastPrice;
  String symbol;
  String pairWith;
  bool currency;
  int decimalCurrency;

  ExchangeScreenCoinModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.lastPrice,
    required this.symbol,
    required this.pairWith,
    required this.currency,
    required this.decimalCurrency
  });

  @override
  String toString() {
    return 'Coin{coinID: $id, coinImage: $image, coinName: $name, coinPrice: $price, coinLastPrice: $lastPrice, coinSymbol: $symbol, coinPairWith: $pairWith, }';
  }
}
