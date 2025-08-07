import 'dart:developer' as dev;
import 'package:logging/logging.dart';

class Logger {
  static late final logging.Logger _logger;

  static void init() {
    _logger = logging.Logger('DartBackend');
    logging.Logger.root.level = Level.ALL;
    logging.Logger.root.onRecord.listen((record) {
      final time = record.time.toString().substring(11, 23);
      final level = record.level.name.padRight(7);
      final message = record.message;

      print('[$time] [$level] $message');

      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('Stack: ${record.stackTrace}');
      }
    });
  }

  static void info(String message) => _logger.info(message);
  static void warning(String message) => _logger.warning(message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
  static void debug(String message) => _logger.fine(message);
}