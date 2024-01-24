class YahooFinanceResponse {
  Chart chart;

  YahooFinanceResponse({required this.chart});

  factory YahooFinanceResponse.fromJson(Map<String, dynamic> json) {
    return YahooFinanceResponse(
      chart: Chart.fromJson(json['chart']),
    );
  }
}


class ChartModel {
  Chart chart;

  ChartModel({required this.chart});

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      chart: Chart.fromJson(json['chart']),
    );
  }
}

class Chart {
  List<Result> result;
  dynamic error;

  Chart({required this.result, this.error});

  factory Chart.fromJson(Map<String, dynamic> json) {
    var resultList = json['result'] as List;
    List<Result> result = resultList.map((e) => Result.fromJson(e)).toList();

    return Chart(
      result: result,
      error: json['error'],
    );
  }
}

class Result {
  YahooCurrencyData meta;
  // List<dynamic> timestamp;
  // Indicators indicators;

  Result({required this.meta,});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      meta: YahooCurrencyData.fromJson(json['meta']),
      // timestamp: json['timestamp'],
      // indicators: Indicators.fromJson(json['indicators']),
    );
  }
}

class YahooCurrencyData {
  String currency;
  String symbol;
  String exchangeName;
  String instrumentType;
  // int firstTradeDate;
  // int regularMarketTime;
  // int gmtoffset;
  // String timezone;
  // String exchangeTimezoneName;
  double regularMarketPrice;
  double chartPreviousClose;
  double previousClose;
  // int scale;
  // int priceHint;
  // CurrentTradingPeriod currentTradingPeriod;
  // List<List<TradingPeriod>> tradingPeriods;
  // String dataGranularity;
  // String range;
  // List<String> validRanges;

  YahooCurrencyData({
    required this.currency,
    required this.symbol,
    required this.exchangeName,
    required this.instrumentType,
    // required this.firstTradeDate,
    // required this.regularMarketTime,
    // required this.gmtoffset,
    // required this.timezone,
    // required this.exchangeTimezoneName,
    required this.regularMarketPrice,
    required this.chartPreviousClose,
    required this.previousClose,
    // required this.scale,
    // required this.priceHint,
    // required this.currentTradingPeriod,
    // required this.tradingPeriods,
    // required this.dataGranularity,
    // required this.range,
    // required this.validRanges,
  });

  factory YahooCurrencyData.fromJson(Map<String, dynamic> json) {
    // var tradingPeriodsList = json['tradingPeriods'] as List;
    // List<List<TradingPeriod>> tradingPeriods = tradingPeriodsList
    //     .map((e) => (e as List)
    //         .map((period) => TradingPeriod.fromJson(period))
    //         .toList())
    //     .toList();

    return YahooCurrencyData(
      currency: json['currency'],
      symbol: json['symbol'],
      exchangeName: json['exchangeName'],
      instrumentType: json['instrumentType'],
      // firstTradeDate: json['firstTradeDate'],
      // regularMarketTime: json['regularMarketTime'],
      // gmtoffset: json['gmtoffset'],
      // timezone: json['timezone'],
      // exchangeTimezoneName: json['exchangeTimezoneName'],
      regularMarketPrice: json['regularMarketPrice'],
      chartPreviousClose: json['chartPreviousClose'],
      previousClose: json['previousClose'],
      // scale: json['scale'],
      // priceHint: json['priceHint'],
      // currentTradingPeriod:
      //     CurrentTradingPeriod.fromJson(json['currentTradingPeriod']),
      // tradingPeriods: tradingPeriods,
      // dataGranularity: json['dataGranularity'],
      // range: json['range'],
      // validRanges: List<String>.from(json['validRanges']),
    );
  }
}

class CurrentTradingPeriod {
  TradingPeriod pre;
  TradingPeriod regular;
  TradingPeriod post;

  CurrentTradingPeriod({
    required this.pre,
    required this.regular,
    required this.post,
  });

  factory CurrentTradingPeriod.fromJson(Map<String, dynamic> json) {
    return CurrentTradingPeriod(
      pre: TradingPeriod.fromJson(json['pre']),
      regular: TradingPeriod.fromJson(json['regular']),
      post: TradingPeriod.fromJson(json['post']),
    );
  }
}

class TradingPeriod {
  String timezone;
  int end;
  int start;
  int gmtoffset;

  TradingPeriod({
    required this.timezone,
    required this.end,
    required this.start,
    required this.gmtoffset,
  });

  factory TradingPeriod.fromJson(Map<String, dynamic> json) {
    return TradingPeriod(
      timezone: json['timezone'],
      end: json['end'],
      start: json['start'],
      gmtoffset: json['gmtoffset'],
    );
  }
}

class Indicators {
  Quote quote;

  Indicators({required this.quote});

  factory Indicators.fromJson(Map<String, dynamic> json) {
    return Indicators(
      quote: Quote.fromJson(json['quote']),
    );
  }
}

class Quote {
  List<double> low;
  List<dynamic> volume;
  List<dynamic> high;
  List<dynamic> close;
  List<dynamic> open;

  Quote({
    required this.low,
    required this.volume,
    required this.high,
    required this.close,
    required this.open,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      low: json['low'],
      volume: json['volume'],
      high: json['high'],
      close: json['close'],
      open: json['open'],
    );
  }
}
