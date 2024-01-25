class YahooFinanceStockResponse {
  Chart chart;

  YahooFinanceStockResponse({required this.chart});

  factory YahooFinanceStockResponse.fromJson(Map<String, dynamic> json) {
    return YahooFinanceStockResponse(
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

  Result({
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      meta: YahooCurrencyData.fromJson(json['meta']),
    );
  }
}

class YahooCurrencyData {
  String currency;
  String symbol;
  String exchangeName;
  String instrumentType;
  double regularMarketPrice;
  double chartPreviousClose;
  double previousClose;

  YahooCurrencyData({
    required this.currency,
    required this.symbol,
    required this.exchangeName,
    required this.instrumentType,
    required this.regularMarketPrice,
    required this.chartPreviousClose,
    required this.previousClose,
  });

  factory YahooCurrencyData.fromJson(Map<String, dynamic> json) {
    return YahooCurrencyData(
      currency: json['currency'],
      symbol: json['symbol'],
      exchangeName: json['exchangeName'],
      instrumentType: json['instrumentType'],
      regularMarketPrice: json['regularMarketPrice'],
      chartPreviousClose: json['chartPreviousClose'],
      previousClose: json['previousClose'],
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
