import 'package:hive/hive.dart';

part 'exchange_screen_coin_model.g.dart';

@HiveType(typeId: 0)
class ExchangeScreenCoinModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String image;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String price;

  @HiveField(4)
  late String lastPrice;

  @HiveField(5)
  late String symbol;

  @HiveField(6)
  late String pairWith;

  @HiveField(7)
  late bool currency;

  @HiveField(8)
  late int decimalCurrency;

  ExchangeScreenCoinModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.lastPrice,
    required this.symbol,
    required this.pairWith,
    required this.currency,
    required this.decimalCurrency,
  });
}