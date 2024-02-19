class BinanceCoins {
  List<SymbolPrice> data;

  BinanceCoins({required this.data});

  factory BinanceCoins.fromJson(List<dynamic> json) {
    List<SymbolPrice> symbolPrices =
        json.map((item) => SymbolPrice.fromJson(item)).toList();

    return BinanceCoins(data: symbolPrices);
  }
}

class SymbolPrice {
  String symbol;
  String price;

  SymbolPrice({required this.symbol, required this.price});

  factory SymbolPrice.fromJson(Map<String, dynamic> json) {
    return SymbolPrice(
      symbol: json['symbol'],
      price: json['price'],
    );
  }
}
