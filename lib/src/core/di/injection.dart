// lib/src/core/di/injection.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import constants
import '../constants/api_constants.dart';
// Import network
import '../network/api_client.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies
class DependencyInjection {
  /// Setup all dependencies
  static Future<void> init() async {
    // Initialize shared preferences first
    await _initSharedPreferences();

    // Register core dependencies
    _registerCore();

    // Register network dependencies
    _registerNetwork();

    // Future: Register repositories when implementations are ready
    // _registerRepositories();

    // Future: Register use cases when needed
    // _registerUseCases();

    // Future: Register cubits/blocs when needed
    // _registerBlocs();
  }

  /// Initialize SharedPreferences
  static Future<void> _initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }

  /// Register core dependencies
  static void _registerCore() {
    // Register Dio instance
    getIt.registerLazySingleton<Dio>(() => _createDio());
  }

  /// Register network dependencies
  static void _registerNetwork() {
    // Register API client
    getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final dio = Dio();

    // Base configuration
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
      headers: ApiConstants.defaultHeaders,
    );

    // Add interceptors
    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _CacheInterceptor(),
    ]);

    return dio;
  }

  /// Reset all dependencies (useful for testing)
  static Future<void> reset() async {
    await getIt.reset();
  }

  /// Check if a dependency is registered
  static bool isRegistered<T extends Object>() {
    return getIt.isRegistered<T>();
  }
}

/// Authentication interceptor to add auth tokens
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Get auth token from shared preferences
      if (getIt.isRegistered<SharedPreferences>()) {
        final sharedPreferences = getIt<SharedPreferences>();
        final token = sharedPreferences.getString(
          ApiConstants.storageKeyAuthToken,
        );

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      // Log error but continue with request
      print('Auth Interceptor Error: $e');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {
      try {
        // Clear stored tokens
        if (getIt.isRegistered<SharedPreferences>()) {
          final sharedPreferences = getIt<SharedPreferences>();
          sharedPreferences.remove(ApiConstants.storageKeyAuthToken);
          sharedPreferences.remove(ApiConstants.storageKeyRefreshToken);
        }

        // Future: Optionally trigger logout navigation
        // You can emit an event or use a stream to notify the app
      } catch (e) {
        print('Auth Error Handler Error: $e');
      }
    }

    handler.next(err);
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Message: ${err.message}');
    if (err.response != null) {
      print('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      default:
        errorMessage = 'An unexpected error occurred';
    }

    // Create a custom error with user-friendly message
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    handler.next(customError);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Cache interceptor for caching responses
class _CacheInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GET requests
    if (options.method.toLowerCase() != 'get') {
      handler.next(options);
      return;
    }

    final cacheKey = _getCacheKey(options);
    final cacheEntry = _cache[cacheKey];

    // Check if we have a valid cached response
    if (cacheEntry != null && !cacheEntry.isExpired) {
      handler.resolve(cacheEntry.response);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only cache successful GET responses
    if (response.requestOptions.method.toLowerCase() == 'get' &&
        response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      final cacheDuration = _getCacheDuration(response.requestOptions.path);

      _cache[cacheKey] = CacheEntry(
        response: response,
        expiryTime: DateTime.now().add(Duration(seconds: cacheDuration)),
      );
    }

    handler.next(response);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.queryParameters}';
  }

  int _getCacheDuration(String path) {
    // Set different cache durations for different endpoints
    if (path.contains('/stocks/quote')) {
      return ApiConstants.shortCacheDuration; // 5 minutes for stock quotes
    } else if (path.contains('/portfolios')) {
      return ApiConstants.mediumCacheDuration; // 30 minutes for portfolios
    } else {
      return ApiConstants.longCacheDuration; // 1 hour for other data
    }
  }

  void clearCache() {
    _cache.clear();
  }
}

/// Cache entry model
class CacheEntry {
  final Response response;
  final DateTime expiryTime;

  CacheEntry({required this.response, required this.expiryTime});

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

/// Extension to easily access dependencies
extension GetItExtension on Object {
  T get<T extends Object>() => getIt<T>();
}

/// Helper functions for common dependencies
class DI {
  static ApiClient get apiClient => getIt<ApiClient>();
  static SharedPreferences get sharedPreferences => getIt<SharedPreferences>();
  static Dio get dio => getIt<Dio>();

  // Future: Add repository getters when implemented
  // static AuthRepository get authRepository => getIt<AuthRepository>();
  // static UserRepository get userRepository => getIt<UserRepository>();
  // static PortfolioRepository get portfolioRepository => getIt<PortfolioRepository>();
  // static StockRepository get stockRepository => getIt<StockRepository>();
}
