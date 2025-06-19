// lib/src/core/constants/api_constants.dart

class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://localhost:8080/api';
  static const String baseUrlProduction = 'https://your-production-url.com/api';

  // External APIs
  static const String alphaVantageBaseUrl = 'https://www.alphavantage.co/query';
  static const String yahooFinanceBaseUrl = 'https://query1.finance.yahoo.com/v8/finance/chart';
  static const String finnhubBaseUrl = 'https://finnhub.io/api/v1';

  // API Keys (These should be in environment variables in production)
  static const String alphaVantageApiKey = 'YOUR_ALPHA_VANTAGE_KEY';
  static const String finnhubApiKey = 'YOUR_FINNHUB_KEY';

  // Authentication Endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authProfile = '/auth/profile';
  static const String authChangePassword = '/auth/change-password';

  // User Endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String userUpdate = '/users/update';
  static const String userDelete = '/users/delete';

  // Portfolio Endpoints
  static const String portfolios = '/portfolios';
  static const String portfolioById = '/portfolios/{id}';
  static const String portfolioCreate = '/portfolios';
  static const String portfolioUpdate = '/portfolios/{id}';
  static const String portfolioDelete = '/portfolios/{id}';
  static const String portfolioSummary = '/portfolios/{id}/summary';
  static const String portfolioPerformance = '/portfolios/{id}/performance';

  // Stock Endpoints
  static const String stocks = '/stocks';
  static const String stockById = '/stocks/{id}';
  static const String stocksByPortfolio = '/portfolios/{portfolioId}/stocks';
  static const String stockCreate = '/portfolios/{portfolioId}/stocks';
  static const String stockUpdate = '/stocks/{id}';
  static const String stockDelete = '/stocks/{id}';
  static const String stockQuote = '/stocks/{symbol}/quote';
  static const String stockHistory = '/stocks/{symbol}/history';
  static const String stockSearch = '/stocks/search';

  // Dashboard Endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardPerformance = '/dashboard/performance';
  static const String dashboardAllocation = '/dashboard/allocation';

  // Market Data Endpoints
  static const String marketQuote = '/market/quote/{symbol}';
  static const String marketSearch = '/market/search';
  static const String marketTrending = '/market/trending';
  static const String marketNews = '/market/news';
  static const String marketSectors = '/market/sectors';

  // Watchlist Endpoints
  static const String watchlist = '/watchlist';
  static const String watchlistAdd = '/watchlist/add';
  static const String watchlistRemove = '/watchlist/remove/{symbol}';

  // External Stock API Endpoints
  static const String alphaVantageQuote = 'function=GLOBAL_QUOTE&symbol={symbol}&apikey={apikey}';
  static const String alphaVantageSearch = 'function=SYMBOL_SEARCH&keywords={keywords}&apikey={apikey}';
  static const String alphaVantageDaily = 'function=TIME_SERIES_DAILY&symbol={symbol}&apikey={apikey}';
  static const String alphaVantageIntraday = 'function=TIME_SERIES_INTRADAY&symbol={symbol}&interval=5min&apikey={apikey}';

  static const String finnhubQuote = '/quote?symbol={symbol}&token={token}';
  static const String finnhubProfile = '/stock/profile2?symbol={symbol}&token={token}';
  static const String finnhubNews = '/company-news?symbol={symbol}&from={from}&to={to}&token={token}';
  static const String finnhubCandles = '/stock/candle?symbol={symbol}&resolution=D&from={from}&to={to}&token={token}';

  // Request Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> authHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer {token}',
  };

  // Request Timeouts (in milliseconds)
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Cache Durations (in seconds)
  static const int shortCacheDuration = 300; // 5 minutes
  static const int mediumCacheDuration = 1800; // 30 minutes
  static const int longCacheDuration = 3600; // 1 hour

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Stock Market Hours (Eastern Time)
  static const int marketOpenHour = 9;
  static const int marketOpenMinute = 30;
  static const int marketCloseHour = 16;
  static const int marketCloseMinute = 0;

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerHour = 1000;

  // WebSocket Endpoints (for real-time data)
  static const String websocketUrl = 'ws://localhost:8080/ws';
  static const String websocketUrlProduction = 'wss://your-production-url.com/ws';

  // File Upload
  static const String uploadProfile = '/upload/profile';
  static const String uploadDocument = '/upload/document';
  static const int maxFileSize = 10485760; // 10MB

  // Error Codes
  static const String errorCodeUnauthorized = 'UNAUTHORIZED';
  static const String errorCodeForbidden = 'FORBIDDEN';
  static const String errorCodeNotFound = 'NOT_FOUND';
  static const String errorCodeValidation = 'VALIDATION_ERROR';
  static const String errorCodeServerError = 'SERVER_ERROR';
  static const String errorCodeNetworkError = 'NETWORK_ERROR';
  static const String errorCodeTimeoutError = 'TIMEOUT_ERROR';

  // Response Status
  static const String statusSuccess = 'success';
  static const String statusError = 'error';
  static const String statusLoading = 'loading';

  // Local Storage Keys
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserProfile = 'user_profile';
  static const String storageKeyAppSettings = 'app_settings';
  static const String storageKeyPortfolioCache = 'portfolio_cache';
  static const String storageKeyStockCache = 'stock_cache';

  // Environment
  static const String envDevelopment = 'development';
  static const String envStaging = 'staging';
  static const String envProduction = 'production';

  // Helper methods for dynamic URLs
  static String getStockById(String id) => stockById.replaceAll('{id}', id);
  static String getPortfolioById(String id) => portfolioById.replaceAll('{id}', id);
  static String getStocksByPortfolio(String portfolioId) =>
      stocksByPortfolio.replaceAll('{portfolioId}', portfolioId);
  static String getStockQuote(String symbol) => stockQuote.replaceAll('{symbol}', symbol);
  static String getMarketQuote(String symbol) => marketQuote.replaceAll('{symbol}', symbol);

  // Alpha Vantage helper methods
  static String getAlphaVantageQuoteUrl(String symbol) =>
      '$alphaVantageBaseUrl?${alphaVantageQuote.replaceAll('{symbol}', symbol).replaceAll('{apikey}', alphaVantageApiKey)}';

  static String getAlphaVantageSearchUrl(String keywords) =>
      '$alphaVantageBaseUrl?${alphaVantageSearch.replaceAll('{keywords}', keywords).replaceAll('{apikey}', alphaVantageApiKey)}';

  // Finnhub helper methods
  static String getFinnhubQuoteUrl(String symbol) =>
      '$finnhubBaseUrl${finnhubQuote.replaceAll('{symbol}', symbol).replaceAll('{token}', finnhubApiKey)}';

  static String getFinnhubProfileUrl(String symbol) =>
      '$finnhubBaseUrl${finnhubProfile.replaceAll('{symbol}', symbol).replaceAll('{token}', finnhubApiKey)}';

  // Yahoo Finance helper methods
  static String getYahooFinanceQuoteUrl(String symbol) =>
      '$yahooFinanceBaseUrl/$symbol';
}