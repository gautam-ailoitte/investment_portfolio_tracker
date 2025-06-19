import 'package:personal/src/domain/entities/stock.dart';

class Portfolio {
  final String? id;
  final String? userId;
  final String? name;
  final String? description;
  final double? totalValue;
  final double? totalCost;
  final double? totalGainLoss;
  final double? totalGainLossPercentage;
  final double? todaysGain;
  final double? todaysGainPercentage;
  final List<Stock>? stocks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Portfolio({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.totalValue,
    this.totalCost,
    this.totalGainLoss,
    this.totalGainLossPercentage,
    this.todaysGain,
    this.todaysGainPercentage,
    this.stocks,
    this.createdAt,
    this.updatedAt,
  });

  Portfolio copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? totalValue,
    double? totalCost,
    double? totalGainLoss,
    double? totalGainLossPercentage,
    double? todaysGain,
    double? todaysGainPercentage,
    List<Stock>? stocks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Portfolio(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      totalValue: totalValue ?? this.totalValue,
      totalCost: totalCost ?? this.totalCost,
      totalGainLoss: totalGainLoss ?? this.totalGainLoss,
      totalGainLossPercentage:
          totalGainLossPercentage ?? this.totalGainLossPercentage,
      todaysGain: todaysGain ?? this.todaysGain,
      todaysGainPercentage: todaysGainPercentage ?? this.todaysGainPercentage,
      stocks: stocks ?? this.stocks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get stock count
  int get stockCount => stocks?.length ?? 0;

  /// Check if portfolio has stocks
  bool get hasStocks => stockCount > 0;

  /// Check if portfolio is profitable
  bool get isProfitable => (totalGainLoss ?? 0) > 0;

  @override
  String toString() {
    return 'Portfolio(id: $id, name: $name, totalValue: $totalValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Portfolio && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
