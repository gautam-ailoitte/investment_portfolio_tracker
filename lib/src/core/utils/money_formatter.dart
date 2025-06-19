// lib/src/core/utils/money_formatter.dart

import 'dart:math';

import 'package:intl/intl.dart';

/// Custom money formatter utility to replace money_formatter package
class MoneyFormatter {
  static const String defaultCurrencySymbol = '\$';
  static const String defaultLocale = 'en_US';

  /// Format amount as currency with symbol
  static String formatCurrency(
    double amount, {
    String symbol = defaultCurrencySymbol,
    int decimalDigits = 2,
    String locale = defaultLocale,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(amount);
  }

  /// Format amount as compact currency (e.g., $1.2K, $2.5M)
  static String formatCompactCurrency(
    double amount, {
    String symbol = defaultCurrencySymbol,
    String locale = defaultLocale,
  }) {
    if (amount.abs() < 1000) {
      return formatCurrency(amount, symbol: symbol, locale: locale);
    }

    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      locale: locale,
    );
    return formatter.format(amount);
  }

  /// Format amount without currency symbol
  static String formatAmount(
    double amount, {
    int decimalDigits = 2,
    String locale = defaultLocale,
  }) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(amount).trim();
  }

  /// Format amount with + or - prefix for gains/losses
  static String formatGainLoss(
    double amount, {
    String symbol = defaultCurrencySymbol,
    int decimalDigits = 2,
    String locale = defaultLocale,
    bool showPlus = true,
  }) {
    final formatted = formatCurrency(
      amount.abs(),
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );

    if (amount > 0) {
      return showPlus ? '+$formatted' : formatted;
    } else if (amount < 0) {
      return '-$formatted';
    } else {
      return formatted;
    }
  }

  /// Format percentage
  static String formatPercentage(
    double percentage, {
    int decimalDigits = 2,
    bool showPlus = false,
  }) {
    final formatter = NumberFormat.percentPattern();
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;

    final formatted = formatter.format(percentage / 100);

    if (percentage > 0 && showPlus) {
      return '+$formatted';
    }

    return formatted;
  }

  /// Format large numbers with suffixes (K, M, B, T)
  static String formatWithSuffix(
    double amount, {
    int decimalDigits = 1,
    String symbol = defaultCurrencySymbol,
  }) {
    if (amount.abs() < 1000) {
      return formatCurrency(amount, symbol: symbol, decimalDigits: 0);
    }

    const List<String> suffixes = ['', 'K', 'M', 'B', 'T'];
    int suffixIndex = 0;
    double value = amount;

    while (value.abs() >= 1000 && suffixIndex < suffixes.length - 1) {
      value /= 1000;
      suffixIndex++;
    }

    final formatter = NumberFormat('0.${'#' * decimalDigits}');
    return '$symbol${formatter.format(value)}${suffixes[suffixIndex]}';
  }

  /// Parse currency string to double
  static double? parseCurrency(String currencyString) {
    // Remove currency symbols and formatting
    final cleaned = currencyString
        .replaceAll(RegExp(r'[^\d.-]'), '')
        .replaceAll(',', '');

    return double.tryParse(cleaned);
  }

  /// Get currency symbol for locale
  static String getCurrencySymbol(String locale) {
    final formatter = NumberFormat.simpleCurrency(locale: locale);
    return formatter.currencySymbol;
  }

  /// Format market cap
  static String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '${(marketCap / 1e6).toStringAsFixed(2)}M';
    } else if (marketCap >= 1e3) {
      return '${(marketCap / 1e3).toStringAsFixed(2)}K';
    } else {
      return marketCap.toStringAsFixed(2);
    }
  }

  /// Format volume (shares)
  static String formatVolume(int volume) {
    if (volume >= 1e9) {
      return '${(volume / 1e9).toStringAsFixed(1)}B';
    } else if (volume >= 1e6) {
      return '${(volume / 1e6).toStringAsFixed(1)}M';
    } else if (volume >= 1e3) {
      return '${(volume / 1e3).toStringAsFixed(1)}K';
    } else {
      return volume.toString();
    }
  }

  /// Round to specific decimal places
  static double roundTo(double value, int places) {
    final mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  /// Format price change with appropriate color coding info
  static Map<String, dynamic> formatPriceChange(
    double change,
    double changePercentage, {
    String symbol = defaultCurrencySymbol,
  }) {
    final changeFormatted = formatGainLoss(change, symbol: symbol);
    final percentageFormatted = formatPercentage(
      changePercentage,
      showPlus: true,
    );

    final isPositive = change > 0;
    final isNegative = change < 0;

    return {
      'changeFormatted': changeFormatted,
      'percentageFormatted': percentageFormatted,
      'combinedFormatted': '$changeFormatted ($percentageFormatted)',
      'isPositive': isPositive,
      'isNegative': isNegative,
      'isNeutral': change == 0,
      'colorHex': isPositive
          ? '#10B981' // Green
          : isNegative
          ? '#EF4444' // Red
          : '#6B7280', // Gray
    };
  }

  /// Format allocation percentage
  static String formatAllocation(double percentage) {
    if (percentage < 0.01) {
      return '<0.01%';
    } else if (percentage >= 99.99) {
      return '>99.99%';
    } else {
      return '${percentage.toStringAsFixed(2)}%';
    }
  }

  /// Format shares count
  static String formatShares(double shares) {
    if (shares == shares.roundToDouble()) {
      return shares.toInt().toString();
    } else {
      return shares.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  /// Format P/E ratio
  static String formatPERatio(double? peRatio) {
    if (peRatio == null || peRatio <= 0) {
      return 'N/A';
    } else if (peRatio > 999) {
      return '>999';
    } else {
      return peRatio.toStringAsFixed(2);
    }
  }

  /// Format dividend yield
  static String formatDividendYield(double? yield) {
    if (yield == null || yield <= 0) {
      return 'N/A';
    } else {
      return '${yield.toStringAsFixed(2)}%';
    }
  }
}

/// Extension on double for easy money formatting
extension MoneyFormatterExtension on double {
  /// Format as currency
  String get currency => MoneyFormatter.formatCurrency(this);

  /// Format as compact currency
  String get compactCurrency => MoneyFormatter.formatCompactCurrency(this);

  /// Format as gain/loss
  String get gainLoss => MoneyFormatter.formatGainLoss(this);

  /// Format as percentage
  String get percentage => MoneyFormatter.formatPercentage(this);

  /// Format with suffix (K, M, B, T)
  String get withSuffix => MoneyFormatter.formatWithSuffix(this);

  /// Format as market cap
  String get marketCap => MoneyFormatter.formatMarketCap(this);
}

/// Extension on int for volume formatting
extension VolumeFormatterExtension on int {
  /// Format as volume
  String get volume => MoneyFormatter.formatVolume(this);
}
