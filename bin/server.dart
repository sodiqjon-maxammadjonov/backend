
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import '../lib/app.dart';
import '../lib/core/utils/logger.dart';

void main(List<String> arguments) async {
  // Load environment variables
  final env = DotEnv(includePlatformEnvironment: true)..load();

  // Initialize logger
  Logger.init();

  try {
    // Create app instance
    final app = App(env);
    await app.initialize();

    // Get server configuration
    final port = int.parse(env['PORT'] ?? '8080');
    final host = env['HOST'] ?? '0.0.0.0';

    // Start server
    final server = await io.serve(
      app.handler,
      host,
      port,
    );

    Logger.info('🚀 Server running on http://${server.address.host}:${server.port}');
    Logger.info('🌍 Environment: ${env['ENV'] ?? 'development'}');

    // Graceful shutdown
    ProcessSignal.sigint.watch().listen((signal) async {
      Logger.info('🛑 Shutting down server...');
      await server.close();
      await app.dispose();
      Logger.info('✅ Server stopped gracefully');
      exit(0);
    });

  } catch (e, stackTrace) {
    Logger.error('❌ Failed to start server: $e', stackTrace);
    exit(1);
  }
}