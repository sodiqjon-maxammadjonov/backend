import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart';
import 'core/middleware/cors_middleware.dart';
import 'core/middleware/logging_middleware.dart';
import 'core/middleware/error_middleware.dart';
import 'core/middleware/auth_middleware.dart';
import 'core/security/jwt_service.dart';
import 'core/security/password_service.dart';
import 'shared/database/database_config.dart';
import 'features/auth/presentation/routes/auth_routes.dart';
import 'core/utils/logger.dart';

class App {
  final DotEnv _env;
  late final DatabaseConfig _database;
  late final JwtService _jwtService;
  late final PasswordService _passwordService;
  late final Handler _handler;

  App(this._env);

  Future<void> initialize() async {
    Logger.info('🔧 Initializing application...');

    // Initialize services
    await _initializeServices();

    // Setup routes and middleware
    _setupHandler();

    Logger.info('✅ Application initialized successfully');
  }

  Future<void> _initializeServices() async {
    // Initialize database
    _database = DatabaseConfig(_env);
    await _database.initialize();

    // Initialize security services
    _jwtService = JwtService(_env);
    _passwordService = PasswordService(_env);

    Logger.info('🔐 Security services initialized');
  }

  void _setupHandler() {
    final router = Router();

    // Health check endpoint
    router.get('/health', (Request request) {
      return Response.ok(
        '{"status": "healthy", "timestamp": "${DateTime.now().toIso8601String()}"}',
        headers: {'content-type': 'application/json'},
      );
    });

    // API routes
    router.mount('/api/v1/auth', AuthRoutes(_jwtService, _passwordService, _database).router);

    // Setup middleware pipeline
    _handler = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(errorMiddleware())
        .addHandler(router.call);
  }

  Handler get handler => _handler;

  Future<void> dispose() async {
    Logger.info('🧹 Cleaning up resources...');
    await _database.dispose();
    Logger.info('✅ Cleanup completed');
  }
}
