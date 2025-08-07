import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

Middleware errorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        Logger.error('Unhandled error in ${request.method} ${request.url.path}', error, stackTrace);

        return _handleError(error);
      }
    };
  };
}

Response _handleError(dynamic error) {
  if (error is AppException) {
    return Response(
      error.statusCode,
      body: jsonEncode({
        'success': false,
        'error': {
          'code': error.code,
          'message': error.message,
        },
        'timestamp': DateTime.now().toIso8601String(),
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  // Default internal server error
  return Response.internalServerError(
    body: jsonEncode({
      'success': false,
      'error': {
        'code': 'INTERNAL_SERVER_ERROR',
        'message': 'An unexpected error occurred',
      },
      'timestamp': DateTime.now().toIso8601String(),
    }),
    headers: {'content-type': 'application/json'},
  );
}
