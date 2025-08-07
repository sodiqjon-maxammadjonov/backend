class AppConstants {
  // Application info
  static const String appName = 'Dart Backend API';
  static const String appVersion = '1.0.0';

  // JWT
  static const Duration defaultJwtExpiry = Duration(hours: 24);
  static const Duration defaultRefreshTokenExpiry = Duration(days: 7);

  // Password
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int defaultBcryptRounds = 12;

  // Rate limiting
  static const int defaultRateLimit = 100;
  static const Duration defaultRateLimitWindow = Duration(minutes: 15);

  // Database
  static const int defaultConnectionTimeout = 30;
  static const int defaultQueryTimeout = 30;
  static const int maxConnectionPoolSize = 10;

  // Validation
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,30}$';

  // Error codes
  static const String userNotFoundError = 'USER_NOT_FOUND';
  static const String invalidCredentialsError = 'INVALID_CREDENTIALS';
  static const String userAlreadyExistsError = 'USER_ALREADY_EXISTS';
  static const String invalidTokenError = 'INVALID_TOKEN';
  static const String tokenExpiredError = 'TOKEN_EXPIRED';
  static const String validationError = 'VALIDATION_ERROR';
  static const String databaseError = 'DATABASE_ERROR';
  static const String internalServerError = 'INTERNAL_SERVER_ERROR';
}