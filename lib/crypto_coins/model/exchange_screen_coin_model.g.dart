// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_screen_coin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExchangeScreenCoinModelAdapter
    extends TypeAdapter<ExchangeScreenCoinModel> {
  @override
  final int typeId = 0;

  @override
  ExchangeScreenCoinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExchangeScreenCoinModel(
      id: fields[0] as String,
      image: fields[1] as String,
      name: fields[2] as String,
      currencyCode: fields[4] as String,
      price: fields[3] as String,
      lastPrice: fields[5] as String,
      symbol: fields[6] as String,
      pairWith: fields[7] as String,
      currency: fields[8] as bool,
      decimalCurrency: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExchangeScreenCoinModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.lastPrice)
      ..writeByte(6)
      ..write(obj.symbol)
      ..writeByte(7)
      ..write(obj.pairWith)
      ..writeByte(8)
      ..write(obj.currency)
      ..writeByte(9)
      ..write(obj.decimalCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeScreenCoinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
