import 'dart:async';
import 'package:http/http.dart' as http;

/// Custom exception thrown when the server returns a non-200 HTTP status code.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Converts any caught [error] into a human-readable message per the technical requirements.
///
/// This helper is placed here so that Screens/Widgets don't need to import the http package.
String errorMessage(Object error) {
  final errorStr = error.toString();

  // SocketException - No internet connection
  if (errorStr.contains('SocketException') ||
      errorStr.contains('Connection failed') ||
      error is http.ClientException) {
    return 'No internet connection';
  }

  // TimeoutException - Request timed out
  if (error is TimeoutException) {
    return 'Request timed out. Please try again.';
  }

  // ApiException - Status code + message
  if (error is ApiException) {
    return 'Server error ${error.statusCode}: ${error.message}';
  }

  // FormatException - Unexpected data format
  if (error is FormatException) {
    return 'Unexpected data format received';
  }

  // Generic Exception - Catch-all
  return 'An unexpected error occurred: ${error.toString()}';
}
