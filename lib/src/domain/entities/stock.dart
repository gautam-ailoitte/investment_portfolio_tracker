class Stock {
  final String? id;
  final String? portfolioId;
  final String? symbol;
  final String? companyName;
  final String? logoUrl;
  final double? purchasePrice;
  final double? currentPrice;
  final double? shares;
  final double? totalCost;
  final double? marketValue;
  final double? gainLoss;
  final double? gainLossPercentage;
  final double? todaysChange;
  final double? todaysChangePercentage;
  final String? sector;
  final String? industry;
  final DateTime? purchaseDate;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Stock({
    this.id,
    this.portfolioId,
    this.symbol,
    this.companyName,
    this.logoUrl,
    this.purchasePrice,
    this.currentPrice,
    this.shares,
    this.totalCost,
    this.marketValue,
    this.gainLoss,
    this.gainLossPercentage,
    this.todaysChange,
    this.todaysChangePercentage,
    this.sector,
    this.industry,
    this.purchaseDate,
    this.lastUpdated,
    this.createdAt,
    this.updatedAt,
  });

  Stock copyWith({
    String? id,
    String? portfolioId,
    String? symbol,
    String? companyName,
    String? logoUrl,
    double? purchasePrice,
    double? currentPrice,
    double? shares,
    double? totalCost,
    double? marketValue,
    double? gainLoss,
    double? gainLossPercentage,
    double? todaysChange,
    double? todaysChangePercentage,
    String? sector,
    String? industry,
    DateTime? purchaseDate,
    DateTime? lastUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Stock(
      id: id ?? this.id,
      portfolioId: portfolioId ?? this.portfolioId,
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      logoUrl: logoUrl ?? this.logoUrl,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      shares: shares ?? this.shares,
      totalCost: totalCost ?? this.totalCost,
      marketValue: marketValue ?? this.marketValue,
      gainLoss: gainLoss ?? this.gainLoss,
      gainLossPercentage: gainLossPercentage ?? this.gainLossPercentage,
      todaysChange: todaysChange ?? this.todaysChange,
      todaysChangePercentage:
          todaysChangePercentage ?? this.todaysChangePercentage,
      sector: sector ?? this.sector,
      industry: industry ?? this.industry,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if stock is profitable
  bool get isProfitable => (gainLoss ?? 0) > 0;

  /// Check if stock is up today
  bool get isUpToday => (todaysChange ?? 0) > 0;

  /// Get formatted symbol for display
  String get displaySymbol => symbol?.toUpperCase() ?? '';

  /// Get percentage allocation in portfolio
  double getAllocationPercentage(double portfolioValue) {
    if (portfolioValue <= 0 || (marketValue ?? 0) <= 0) return 0;
    return ((marketValue! / portfolioValue) * 100);
  }

  @override
  String toString() {
    return 'Stock(id: $id, symbol: $symbol, companyName: $companyName, currentPrice: $currentPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Stock && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class StockQuote {
  final String? symbol;
  final double? price;
  final double? change;
  final double? changePercentage;
  final double? previousClose;
  final double? open;
  final double? high;
  final double? low;
  final int? volume;
  final double? marketCap;
  final double? peRatio;
  final DateTime? timestamp;

  const StockQuote({
    this.symbol,
    this.price,
    this.change,
    this.changePercentage,
    this.previousClose,
    this.open,
    this.high,
    this.low,
    this.volume,
    this.marketCap,
    this.peRatio,
    this.timestamp,
  });

  StockQuote copyWith({
    String? symbol,
    double? price,
    double? change,
    double? changePercentage,
    double? previousClose,
    double? open,
    double? high,
    double? low,
    int? volume,
    double? marketCap,
    double? peRatio,
    DateTime? timestamp,
  }) {
    return StockQuote(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercentage: changePercentage ?? this.changePercentage,
      previousClose: previousClose ?? this.previousClose,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Check if stock is up
  bool get isUp => (change ?? 0) > 0;

  /// Check if stock is down
  bool get isDown => (change ?? 0) < 0;

  /// Check if data is stale (older than 15 minutes)
  bool get isStale {
    if (timestamp == null) return true;
    final fifteenMinutesAgo = DateTime.now().subtract(
      const Duration(minutes: 15),
    );
    return timestamp!.isBefore(fifteenMinutesAgo);
  }

  @override
  String toString() {
    return 'StockQuote(symbol: $symbol, price: $price, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockQuote &&
        other.symbol == symbol &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(symbol, timestamp);
}
