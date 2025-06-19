import '../entities/stock.dart';

abstract class StockRepository {
  /// Get stock by ID
  Future<Stock> getStockById(String stockId);

  /// Get real-time stock quote
  Future<StockQuote> getStockQuote(String symbol);

  /// Get multiple stock quotes
  Future<List<StockQuote>> getStockQuotes(List<String> symbols);

  /// Search stocks by symbol or company name
  Future<List<Stock>> searchStocks(String query);

  /// Get stock suggestions/autocomplete
  Future<List<String>> getStockSuggestions(String query);

  /// Get stock company information
  Future<Map<String, dynamic>> getStockCompanyInfo(String symbol);

  /// Get stock historical prices
  Future<List<Map<String, dynamic>>> getStockHistory({
    required String symbol,
    String? period, // 1D, 1W, 1M, 3M, 1Y, 5Y, MAX
    String? interval, // 1m, 5m, 15m, 30m, 1h, 1d, 1wk, 1mo
  });

  /// Get stock news
  Future<List<Map<String, dynamic>>> getStockNews({
    required String symbol,
    int? limit,
  });

  /// Get trending stocks
  Future<List<Stock>> getTrendingStocks();

  /// Get top gainers
  Future<List<StockQuote>> getTopGainers();

  /// Get top losers
  Future<List<StockQuote>> getTopLosers();

  /// Get most active stocks
  Future<List<StockQuote>> getMostActiveStocks();

  /// Get sector performance
  Future<Map<String, dynamic>> getSectorPerformance();

  /// Get market indices (S&P 500, NASDAQ, DOW)
  Future<List<StockQuote>> getMarketIndices();

  /// Add stock to watchlist
  Future<void> addToWatchlist(String symbol);

  /// Remove stock from watchlist
  Future<void> removeFromWatchlist(String symbol);

  /// Get watchlist stocks
  Future<List<Stock>> getWatchlistStocks();

  /// Check if stock is in watchlist
  Future<bool> isInWatchlist(String symbol);

  /// Set price alert for stock
  Future<void> setPriceAlert({
    required String symbol,
    required double targetPrice,
    required String alertType, // 'above' or 'below'
  });

  /// Get price alerts
  Future<List<Map<String, dynamic>>> getPriceAlerts();

  /// Delete price alert
  Future<void> deletePriceAlert(String alertId);

  /// Get stock technical indicators
  Future<Map<String, dynamic>> getStockTechnicalIndicators({
    required String symbol,
    String? period,
  });

  /// Check if market is open
  Future<bool> isMarketOpen();

  /// Get market status
  Future<Map<String, dynamic>> getMarketStatus();

  /// Stream of real-time stock quotes
  Stream<StockQuote> stockQuoteStream(String symbol);

  /// Stream of watchlist updates
  Stream<List<Stock>> get watchlistStream;
}
