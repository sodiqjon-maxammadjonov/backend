import 'package:shelf/shelf.dart';
import '../utils/logger.dart';

Middleware loggingMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final startTime = DateTime.now();

      Logger.info('➡️  ${request.method} ${request.requestedUri.path}');

      try {
        final response = await innerHandler(request);
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime).inMilliseconds;

        Logger.info('⬅️  ${response.statusCode} ${request.method} ${request.requestedUri.path} ${duration}ms');

        return response;
      } catch (error, stackTrace) {
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime).inMilliseconds;

        Logger.error('❌ ${request.method} ${request.requestedUri.path} ${duration}ms - Error: $error', error, stackTrace);
        rethrow;
      }
    };
  };
}
