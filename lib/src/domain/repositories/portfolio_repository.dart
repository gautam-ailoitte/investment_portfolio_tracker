import '../entities/dashboard_summary.dart';
import '../entities/portfolio.dart';
import '../entities/stock.dart';

abstract class PortfolioRepository {
  /// Get all portfolios for current user
  Future<List<Portfolio>> getPortfolios();

  /// Get portfolio by ID
  Future<Portfolio> getPortfolioById(String portfolioId);

  /// Create new portfolio
  Future<Portfolio> createPortfolio({
    required String name,
    String? description,
  });

  /// Update portfolio
  Future<Portfolio> updatePortfolio({
    required String portfolioId,
    String? name,
    String? description,
  });

  /// Delete portfolio
  Future<void> deletePortfolio(String portfolioId);

  /// Get portfolio summary (value, gains, etc.)
  Future<Portfolio> getPortfolioSummary(String portfolioId);

  /// Get portfolio performance over time
  Future<Map<String, dynamic>> getPortfolioPerformance({
    required String portfolioId,
    String? period, // 1D, 1W, 1M, 3M, 1Y, ALL
  });

  /// Get portfolio allocation (by sector, stock, etc.)
  Future<Map<String, dynamic>> getPortfolioAllocation(String portfolioId);

  /// Get stocks in portfolio
  Future<List<Stock>> getPortfolioStocks(String portfolioId);

  /// Add stock to portfolio
  Future<Stock> addStockToPortfolio({
    required String portfolioId,
    required String symbol,
    String? companyName,
    required double purchasePrice,
    required double shares,
    required DateTime purchaseDate,
  });

  /// Update stock in portfolio
  Future<Stock> updateStock({
    required String stockId,
    double? purchasePrice,
    double? shares,
    DateTime? purchaseDate,
  });

  /// Remove stock from portfolio
  Future<void> removeStockFromPortfolio(String stockId);

  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary();

  /// Refresh portfolio data (update current prices)
  Future<void> refreshPortfolioData(String portfolioId);

  /// Refresh all portfolios data
  Future<void> refreshAllPortfoliosData();

  /// Export portfolio to CSV
  Future<String> exportPortfolioToCsv(String portfolioId);

  /// Import portfolio from CSV
  Future<Portfolio> importPortfolioFromCsv({
    required String portfolioId,
    required String csvData,
  });

  /// Get portfolio history
  Future<List<Map<String, dynamic>>> getPortfolioHistory({
    required String portfolioId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Stream of portfolio updates
  Stream<List<Portfolio>> get portfoliosStream;

  /// Stream of specific portfolio updates
  Stream<Portfolio> portfolioStream(String portfolioId);
}
