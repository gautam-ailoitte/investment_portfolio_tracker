// lib/src/core/network/api_client.dart

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// API client wrapper around Dio for HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle and transform errors
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout',
          statusCode: null,
          errorCode: ApiConstants.errorCodeTimeoutError,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout',
          statusCode: null,
          errorCode: ApiConstants.errorCodeTimeoutError,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout',
          statusCode: null,
          errorCode: ApiConstants.errorCodeTimeoutError,
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          statusCode: null,
          errorCode: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Network error. Please check your internet connection.',
          statusCode: null,
          errorCode: ApiConstants.errorCodeNetworkError,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred',
          statusCode: null,
          errorCode: 'UNKNOWN_ERROR',
        );
    }
  }

  /// Handle response errors (4xx, 5xx)
  ApiException _handleResponseError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final responseData = response?.data;

    String message = 'An error occurred';
    String errorCode = ApiConstants.errorCodeServerError;

    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] ?? responseData['error'] ?? message;
      errorCode = responseData['code'] ?? errorCode;
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message.isNotEmpty ? message : 'Bad request',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeValidation,
          errors: _extractValidationErrors(responseData),
        );
      case 401:
        return ApiException(
          message: message.isNotEmpty ? message : 'Unauthorized',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeUnauthorized,
        );
      case 403:
        return ApiException(
          message: message.isNotEmpty ? message : 'Forbidden',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeForbidden,
        );
      case 404:
        return ApiException(
          message: message.isNotEmpty ? message : 'Not found',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeNotFound,
        );
      case 422:
        return ApiException(
          message: message.isNotEmpty ? message : 'Validation failed',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeValidation,
          errors: _extractValidationErrors(responseData),
        );
      case 500:
        return ApiException(
          message: 'Internal server error',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeServerError,
        );
      case 502:
        return ApiException(
          message: 'Bad gateway',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeServerError,
        );
      case 503:
        return ApiException(
          message: 'Service unavailable',
          statusCode: statusCode,
          errorCode: ApiConstants.errorCodeServerError,
        );
      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }

  /// Extract validation errors from response
  Map<String, List<String>>? _extractValidationErrors(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        final Map<String, List<String>> validationErrors = {};
        errors.forEach((key, value) {
          if (value is List) {
            validationErrors[key] = value.cast<String>();
          } else if (value is String) {
            validationErrors[key] = [value];
          }
        });
        return validationErrors.isNotEmpty ? validationErrors : null;
      }
    }
    return null;
  }

  /// Get current base URL
  String get baseUrl => _dio.options.baseUrl;

  /// Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  /// Add or update header
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Clear all custom headers
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll(ApiConstants.defaultHeaders);
  }

  /// Set authorization token
  void setAuthToken(String token) {
    setHeader('Authorization', 'Bearer $token');
  }

  /// Clear authorization token
  void clearAuthToken() {
    removeHeader('Authorization');
  }

  /// Get interceptors
  Interceptors get interceptors => _dio.interceptors;
}

/// Custom API exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String errorCode;
  final Map<String, List<String>>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    required this.errorCode,
    this.errors,
  });

  @override
  String toString() {
    return 'ApiException: $message (Code: $errorCode, Status: $statusCode)';
  }

  /// Check if error is a network error
  bool get isNetworkError => errorCode == ApiConstants.errorCodeNetworkError;

  /// Check if error is a timeout error
  bool get isTimeoutError => errorCode == ApiConstants.errorCodeTimeoutError;

  /// Check if error is unauthorized
  bool get isUnauthorized => statusCode == 401;

  /// Check if error is a validation error
  bool get isValidationError => errorCode == ApiConstants.errorCodeValidation;

  /// Check if error is a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Check if error is a client error (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Get validation error for specific field
  List<String>? getFieldErrors(String field) {
    return errors?[field];
  }

  /// Get first validation error for specific field
  String? getFirstFieldError(String field) {
    final fieldErrors = getFieldErrors(field);
    return fieldErrors?.isNotEmpty == true ? fieldErrors!.first : null;
  }

  /// Check if has validation errors
  bool get hasValidationErrors => errors?.isNotEmpty == true;

  /// Get all validation error messages as a single string
  String get validationErrorsText {
    if (!hasValidationErrors) return '';

    final List<String> allErrors = [];
    errors!.forEach((field, fieldErrors) {
      allErrors.addAll(fieldErrors);
    });

    return allErrors.join('\n');
  }
}

/// Result wrapper for API responses
class ApiResult<T> {
  final T? data;
  final ApiException? error;
  final bool isSuccess;

  const ApiResult._({this.data, this.error, required this.isSuccess});

  /// Create success result
  factory ApiResult.success(T data) {
    return ApiResult._(data: data, isSuccess: true);
  }

  /// Create error result
  factory ApiResult.error(ApiException error) {
    return ApiResult._(error: error, isSuccess: false);
  }

  /// Check if result is error
  bool get isError => !isSuccess;

  /// Get data or throw error
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    } else if (error != null) {
      throw error!;
    } else {
      throw Exception('Result has no data or error');
    }
  }

  /// Transform data if success
  ApiResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      try {
        return ApiResult.success(transform(data as T));
      } catch (e) {
        return ApiResult.error(
          ApiException(message: e.toString(), errorCode: 'TRANSFORM_ERROR'),
        );
      }
    } else {
      return ApiResult.error(error!);
    }
  }

  /// Handle result with callbacks
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(ApiException error) onError,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else {
      return onError(error!);
    }
  }
}
