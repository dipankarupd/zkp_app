import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // General logging (green color)
  static void logGeneral(String message) {
    _logger.log(Level.info, '✅ GENERAL - $message');
  }

  // Request logging
  static void logRequest(String operation, String endpoint, [dynamic payload]) {
    _logger.i('$operation REQUEST - Endpoint: $endpoint');
    if (payload != null) {
      _logger.d('$operation REQUEST - Payload: $payload');
    }
  }

  // Success logging
  static void logSuccess(String operation, int? statusCode, dynamic response) {
    _logger.i('$operation SUCCESS - Status: $statusCode');
    _logger.d('$operation SUCCESS - Response: $response');
  }

  // Error logging
  static void logError(String operation, dynamic error) {
    _logger.e('$operation FAILED - Error type: ${error.runtimeType}');

    if (error is DioException) {
      _logger.e('$operation FAILED - DioError type: ${error.type}');
      _logger
          .e('$operation FAILED - Status code: ${error.response?.statusCode}');
      _logger.e('$operation FAILED - Error message: ${error.message}');
      _logger.e('$operation FAILED - Error response: ${error.response?.data}');
    } else {
      _logger.e('$operation FAILED - Error message: ${error.toString()}');
    }
  }

  // Extract meaningful error message
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return data['message'] as String;
        }
        return 'Server error: ${error.response?.statusCode}';
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout';
        case DioExceptionType.sendTimeout:
          return 'Send timeout';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout';
        case DioExceptionType.connectionError:
          return 'Connection error';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        default:
          return 'Network error: ${error.message}';
      }
    }

    return error.toString();
  }
}
