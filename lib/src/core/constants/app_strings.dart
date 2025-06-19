// lib/src/core/constants/app_strings.dart

class AppStrings {
  // App Info
  static const String appName = 'Stock Tracker';
  static const String appVersion = 'App Version 1.2.3';

  // Authentication
  static const String login = 'Login';
  static const String signUp = 'Sign up';
  static const String register = 'Register';
  static const String createAccount = 'Create Account';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String logIn = 'Log In';
  static const String logout = 'Logout';
  static const String dontHaveAccount = "Don't have an account? Sign up";
  static const String alreadyHaveAccount = 'Already have an account?';

  // Navigation
  static const String home = 'Home';
  static const String portfolio = 'Portfolio';
  static const String search = 'Search';
  static const String news = 'News';
  static const String watchlist = 'Watchlist';
  static const String profile = 'Profile';
  static const String settings = 'Settings';

  // Dashboard
  static const String myInvestments = 'My Investments';
  static const String totalValue = 'Total Value';
  static const String todaysGain = "Today's Gain";
  static const String portfolios = 'Portfolios';
  static const String stocks = 'Stocks';

  // Portfolio
  static const String portfolio1 = 'Portfolio 1';
  static const String portfolio2 = 'Portfolio 2';
  static const String techStocks = 'Tech Stocks';
  static const String energyStocks = 'Energy Stocks';
  static const String portfolioValue = 'Portfolio Value';
  static const String cashBalance = 'Cash Balance';

  // Stocks
  static const String addStock = 'Add Stock';
  static const String stockSymbol = 'Stock Symbol';
  static const String companyName = 'Company Name';
  static const String purchasePrice = 'Purchase Price';
  static const String numberOfShares = 'Number of Shares';
  static const String purchaseDate = 'Purchase Date';
  static const String currentPrice = 'Current Price';
  static const String totalShares = 'Total Shares';
  static const String marketValue = 'Market Value';
  static const String gainLoss = 'Gain/Loss';
  static const String percentChange = 'Percent Change';

  // Company Names & Symbols
  static const String tesla = 'Tesla';
  static const String teslaSymbol = 'TSLA';
  static const String apple = 'Apple';
  static const String appleSymbol = 'AAPL';
  static const String amazon = 'Amazon';
  static const String amazonSymbol = 'AMZN';
  static const String microsoft = 'Microsoft';
  static const String microsoftSymbol = 'MSFT';
  static const String alphabet = 'Alphabet';
  static const String alphabetSymbol = 'GOOGL';
  static const String tech = 'Tech';
  static const String technologyInc = 'Technology Inc.';
  static const String energy = 'Energy';
  static const String energyCorp = 'Energy Corp.';

  // Account & Profile
  static const String account = 'Account';
  static const String notifications = 'Notifications';
  static const String ethanCarter = 'Ethan Carter';
  static const String ethanEmail = 'ethan.carter@email.com';

  // Actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String update = 'Update';
  static const String refresh = 'Refresh';
  static const String viewDetails = 'View Details';
  static const String backToPortfolio = 'Back to Portfolio';

  // Currency & Numbers
  static const String currency = '\$';
  static const String percentSymbol = '%';
  static const String plus = '+';
  static const String minus = '-';

  // Sample Values (for UI examples)
  static const String sampleTotalValue = '\$12,345.67';
  static const String sampleTodaysGain = '+\$567.89';
  static const String samplePortfolio1Value = '\$7,890.12';
  static const String samplePortfolio2Value = '\$4,455.55';
  static const String sampleTechValue = '\$2,345.67';
  static const String sampleEnergyValue = '\$1,234.56';
  static const String sampleCashBalance = '\$5,000.00';
  static const String sampleTeslaPrice = '\$180.50';
  static const String sampleApplePrice = '\$150.25';
  static const String sampleAmazonPrice = '\$3,200.75';
  static const String sampleMicrosoftPrice = '\$250.50';
  static const String sampleAlphabetPrice = '\$2,800.00';

  // Form Placeholders
  static const String enterEmail = 'Enter your email';
  static const String enterPassword = 'Enter your password';
  static const String enterFullName = 'Enter your full name';
  static const String enterStockSymbol = 'Enter stock symbol';
  static const String enterCompanyName = 'Enter company name';
  static const String enterPurchasePrice = 'Enter purchase price';
  static const String enterNumberOfShares = 'Enter number of shares';
  static const String selectPurchaseDate = 'Select purchase date';

  // Error Messages
  static const String errorEmailRequired = 'Email is required';
  static const String errorEmailInvalid = 'Please enter a valid email';
  static const String errorPasswordRequired = 'Password is required';
  static const String errorPasswordTooShort =
      'Password must be at least 6 characters';
  static const String errorPasswordsDontMatch = 'Passwords do not match';
  static const String errorFullNameRequired = 'Full name is required';
  static const String errorStockSymbolRequired = 'Stock symbol is required';
  static const String errorCompanyNameRequired = 'Company name is required';
  static const String errorPurchasePriceRequired = 'Purchase price is required';
  static const String errorPurchasePriceInvalid = 'Please enter a valid price';
  static const String errorNumberOfSharesRequired =
      'Number of shares is required';
  static const String errorNumberOfSharesInvalid =
      'Please enter a valid number';
  static const String errorPurchaseDateRequired = 'Purchase date is required';
  static const String errorNetworkConnection = 'No internet connection';
  static const String errorServerError = 'Server error occurred';
  static const String errorUnknown = 'An unknown error occurred';

  // Success Messages
  static const String successLoginMessage = 'Successfully logged in';
  static const String successRegisterMessage = 'Account created successfully';
  static const String successStockAdded = 'Stock added successfully';
  static const String successStockUpdated = 'Stock updated successfully';
  static const String successStockDeleted = 'Stock deleted successfully';
  static const String successPortfolioCreated =
      'Portfolio created successfully';
  static const String successPortfolioUpdated =
      'Portfolio updated successfully';
  static const String successPortfolioDeleted =
      'Portfolio deleted successfully';

  // Loading Messages
  static const String loadingSigningIn = 'Signing in...';
  static const String loadingCreatingAccount = 'Creating account...';
  static const String loadingPortfolios = 'Loading portfolios...';
  static const String loadingStocks = 'Loading stocks...';
  static const String loadingStockPrices = 'Loading stock prices...';
  static const String loadingProfile = 'Loading profile...';
  static const String loadingData = 'Loading data...';

  // Empty States
  static const String emptyPortfolios = 'No portfolios found';
  static const String emptyStocks = 'No stocks in this portfolio';
  static const String emptyWatchlist = 'Your watchlist is empty';
  static const String emptySearchResults = 'No stocks found';
  static const String addFirstStock = 'Add your first stock to get started';
  static const String createFirstPortfolio = 'Create your first portfolio';

  // Confirmations
  static const String confirmDeleteStock =
      'Are you sure you want to delete this stock?';
  static const String confirmDeletePortfolio =
      'Are you sure you want to delete this portfolio?';
  static const String confirmLogout = 'Are you sure you want to log out?';

  // Time Periods
  static const String today = 'Today';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String thisYear = 'This Year';
  static const String allTime = 'All Time';

  // Chart Labels
  static const String priceChart = 'Price Chart';
  static const String portfolioPerformance = 'Portfolio Performance';
  static const String allocation = 'Allocation';
  static const String diversification = 'Diversification';

  // Settings
  static const String darkMode = 'Dark Mode';
  static const String enableNotifications = 'Enable Notifications';
  static const String priceAlerts = 'Price Alerts';
  static const String newsAlerts = 'News Alerts';
  static const String language = 'Language';
  static const String about = 'About';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String contactSupport = 'Contact Support';
}
