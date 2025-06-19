import '../entities/stock.dart';

abstract class MarketDataRepository {
  /// Get real-time quote for a single stock
  Future<StockQuote> getQuote(String symbol);

  /// Get real-time quotes for multiple stocks
  Future<List<StockQuote>> getQuotes(List<String> symbols);

  /// Search for stocks
  Future<List<Map<String, dynamic>>> searchStocks(String query);

  /// Get company profile
  Future<Map<String, dynamic>> getCompanyProfile(String symbol);

  /// Get historical data
  Future<List<Map<String, dynamic>>> getHistoricalData({
    required String symbol,
    required DateTime startDate,
    required DateTime endDate,
    String? interval,
  });

  /// Get intraday data
  Future<List<Map<String, dynamic>>> getIntradayData({
    required String symbol,
    String? interval,
  });

  /// Get market news
  Future<List<Map<String, dynamic>>> getMarketNews({
    String? category,
    int? limit,
  });

  /// Get company news
  Future<List<Map<String, dynamic>>> getCompanyNews({
    required String symbol,
    int? limit,
  });

  /// Get market movers
  Future<Map<String, List<StockQuote>>> getMarketMovers();

  /// Get sector performance
  Future<Map<String, dynamic>> getSectorPerformance();

  /// Get earnings calendar
  Future<List<Map<String, dynamic>>> getEarningsCalendar({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get economic calendar
  Future<List<Map<String, dynamic>>> getEconomicCalendar({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get insider trading data
  Future<List<Map<String, dynamic>>> getInsiderTrading(String symbol);

  /// Get institutional holdings
  Future<List<Map<String, dynamic>>> getInstitutionalHoldings(String symbol);

  /// Get analyst recommendations
  Future<Map<String, dynamic>> getAnalystRecommendations(String symbol);

  /// Get financial statements
  Future<Map<String, dynamic>> getFinancialStatements({
    required String symbol,
    required String statementType, // 'income', 'balance', 'cash'
    String? period, // 'annual', 'quarterly'
  });

  /// Get key metrics
  Future<Map<String, dynamic>> getKeyMetrics(String symbol);

  /// Get ratios
  Future<Map<String, dynamic>> getRatios(String symbol);

  /// Check if market is open
  Future<bool> isMarketOpen();

  /// Get market hours
  Future<Map<String, dynamic>> getMarketHours();

  /// Get exchange holidays
  Future<List<DateTime>> getExchangeHolidays();

  /// Stream of real-time quotes
  Stream<StockQuote> quoteStream(String symbol);

  /// Stream of market data updates
  Stream<Map<String, dynamic>> get marketDataStream;
}
