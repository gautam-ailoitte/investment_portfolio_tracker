// lib/src/core/utils/extensions.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// String Extensions
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Checks if string is a valid stock symbol (1-5 uppercase letters)
  bool get isValidStockSymbol {
    return RegExp(r'^[A-Z]{1,5}$').hasMatch(this);
  }

  /// Converts string to currency format
  String get toCurrency {
    final number = double.tryParse(this);
    if (number == null) return this;
    return number.toCurrency;
  }

  /// Removes all non-numeric characters
  String get numbersOnly {
    return replaceAll(RegExp(r'[^0-9.]'), '');
  }

  /// Truncates string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Converts string to proper case for company names
  String get toProperCase {
    return toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          if ([
            'and',
            'or',
            'the',
            'a',
            'an',
            'in',
            'on',
            'at',
            'to',
            'for',
            'of',
            'with',
            'by',
          ].contains(word)) {
            return word;
          }
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}

// Double Extensions
extension DoubleExtensions on double {
  /// Formats number as currency
  String get toCurrency {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'en_US',
    );
    return formatter.format(this);
  }

  /// Formats number as currency with custom symbol
  String toCurrencyWithSymbol(String symbol) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      locale: 'en_US',
    );
    return formatter.format(this);
  }

  /// Formats number as currency without symbol (just formatted number)
  String get toCurrencyAmount {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
      locale: 'en_US',
    );
    return formatter.format(this).trim();
  }

  /// Formats number as percentage
  String get toPercentage {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(this / 100);
  }

  /// Formats number with K, M, B suffixes
  String get toCompact {
    final formatter = NumberFormat.compact();
    return formatter.format(this);
  }

  /// Formats number with + or - prefix for gains/losses
  String get toGainLoss {
    final prefix = this >= 0 ? '+' : '';
    return '$prefix${toCurrency}';
  }

  /// Returns color based on positive/negative value
  Color get gainLossColor {
    if (this > 0) return Colors.green;
    if (this < 0) return Colors.red;
    return Colors.grey;
  }

  /// Rounds to specific decimal places
  double roundTo(int places) {
    final mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

// Int Extensions
extension IntExtensions on int {
  /// Converts int to currency
  String get toCurrency => toDouble().toCurrency;

  /// Converts int to compact format
  String get toCompact => toDouble().toCompact;

  /// Formats number with commas
  String get withCommas {
    final formatter = NumberFormat('#,###');
    return formatter.format(this);
  }
}

// DateTime Extensions
extension DateTimeExtensions on DateTime {
  /// Formats date as MM/dd/yyyy
  String get toDateString {
    final formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(this);
  }

  /// Formats date as MMM dd, yyyy
  String get toDisplayDate {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(this);
  }

  /// Formats time as h:mm a
  String get toTimeString {
    final formatter = DateFormat('h:mm a');
    return formatter.format(this);
  }

  /// Formats date and time
  String get toDateTimeString {
    final formatter = DateFormat('MMM dd, yyyy h:mm a');
    return formatter.format(this);
  }

  /// Returns relative time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if date is within the current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Checks if date is within the current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Checks if date is within the current year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Returns start of day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns end of day (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
}

// BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  /// Gets screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Gets screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Gets screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Gets theme data
  ThemeData get theme => Theme.of(this);

  /// Gets text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Checks if device is in dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Gets safe area padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Gets keyboard height
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// Checks if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Shows snackbar
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  /// Shows success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Shows error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  /// Dismisses keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Navigates to new screen
  Future<T?> push<T>(Widget screen) {
    return Navigator.of(
      this,
    ).push<T>(MaterialPageRoute(builder: (_) => screen));
  }

  /// Replaces current screen
  //todo: or can ignore
  /// Pops current screen
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pops until root
  void popToRoot() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}

// List Extensions
extension ListExtensions<T> on List<T> {
  /// Gets element at index or null if out of bounds
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Checks if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Checks if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Gets first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Gets last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Adds element if condition is true
  List<T> addIf(bool condition, T element) {
    if (condition) add(element);
    return this;
  }

  /// Adds elements if condition is true
  List<T> addAllIf(bool condition, Iterable<T> elements) {
    if (condition) addAll(elements);
    return this;
  }
}

// Map Extensions
extension MapExtensions<K, V> on Map<K, V> {
  /// Gets value or default if key doesn't exist
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }

  /// Gets value or null if key doesn't exist
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

// Widget Extensions
extension WidgetExtensions on Widget {
  /// Adds padding to widget
  Widget padding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Adds padding on all sides
  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Adds margin using Container
  Widget margin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  /// Centers the widget
  Widget center() {
    return Center(child: this);
  }

  /// Expands the widget
  Widget expand({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// Makes widget flexible
  Widget flexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  /// Adds gesture detector
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }

  /// Adds hero animation
  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }

  /// Makes widget visible/invisible
  Widget visible(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  /// Adds opacity to widget
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }
}
