class CoinRankModel {
  String name;
  String symbol;
  String marketCap;
  String price;
  String url;

  CoinRankModel(
      {required this.name,
      required this.symbol,
      required this.marketCap,
      required this.price,
      required this.url});

  factory CoinRankModel.fromJson(Map<String, dynamic> json) {
    return CoinRankModel(
        name: json['name'],
        symbol: json['symbol'],
        marketCap: json['marketCap'],
        price: json['price'],
        url: json['iconUrl']);
  }
}
