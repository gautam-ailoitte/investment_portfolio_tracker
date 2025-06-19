import 'package:personal/src/domain/entities/portfolio.dart';
import 'package:personal/src/domain/entities/stock.dart';

class DashboardSummary {
  final double? totalValue;
  final double? totalCost;
  final double? totalGainLoss;
  final double? totalGainLossPercentage;
  final double? todaysGain;
  final double? todaysGainPercentage;
  final double? cashBalance;
  final int? portfolioCount;
  final int? stockCount;
  final List<Portfolio>? topPortfolios;
  final List<Stock>? topStocks;
  final DateTime? lastUpdated;

  const DashboardSummary({
    this.totalValue,
    this.totalCost,
    this.totalGainLoss,
    this.totalGainLossPercentage,
    this.todaysGain,
    this.todaysGainPercentage,
    this.cashBalance,
    this.portfolioCount,
    this.stockCount,
    this.topPortfolios,
    this.topStocks,
    this.lastUpdated,
  });

  DashboardSummary copyWith({
    double? totalValue,
    double? totalCost,
    double? totalGainLoss,
    double? totalGainLossPercentage,
    double? todaysGain,
    double? todaysGainPercentage,
    double? cashBalance,
    int? portfolioCount,
    int? stockCount,
    List<Portfolio>? topPortfolios,
    List<Stock>? topStocks,
    DateTime? lastUpdated,
  }) {
    return DashboardSummary(
      totalValue: totalValue ?? this.totalValue,
      totalCost: totalCost ?? this.totalCost,
      totalGainLoss: totalGainLoss ?? this.totalGainLoss,
      totalGainLossPercentage:
          totalGainLossPercentage ?? this.totalGainLossPercentage,
      todaysGain: todaysGain ?? this.todaysGain,
      todaysGainPercentage: todaysGainPercentage ?? this.todaysGainPercentage,
      cashBalance: cashBalance ?? this.cashBalance,
      portfolioCount: portfolioCount ?? this.portfolioCount,
      stockCount: stockCount ?? this.stockCount,
      topPortfolios: topPortfolios ?? this.topPortfolios,
      topStocks: topStocks ?? this.topStocks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Check if overall portfolio is profitable
  bool get isProfitable => (totalGainLoss ?? 0) > 0;

  /// Check if portfolio is up today
  bool get isUpToday => (todaysGain ?? 0) > 0;

  /// Get total portfolio value including cash
  double get netWorth => (totalValue ?? 0) + (cashBalance ?? 0);

  @override
  String toString() {
    return 'DashboardSummary(totalValue: $totalValue, totalGainLoss: $totalGainLoss)';
  }
}
