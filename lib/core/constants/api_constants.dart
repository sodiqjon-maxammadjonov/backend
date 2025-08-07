class ApiConstants {
  // API Versions
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // Auth endpoints
  static const String authPrefix = '$apiPrefix/auth';
  static const String signInEndpoint = '$authPrefix/signin';
  static const String signUpEndpoint = '$authPrefix/signup';
  static const String refreshTokenEndpoint = '$authPrefix/refresh';
  static const String updatePasswordEndpoint = '$authPrefix/update-password';
  static const String deleteAccountEndpoint = '$authPrefix/delete-account';

  // HTTP Status codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusInternalServerError = 500;

  // Headers
  static const String contentTypeHeader = 'content-type';
  static const String authorizationHeader = 'authorization';
  static const String bearerPrefix = 'Bearer ';

  // Response messages
  static const String successMessage = 'Success';
  static const String errorMessage = 'Error occurred';
  static const String unauthorizedMessage = 'Unauthorized access';
  static const String notFoundMessage = 'Resource not found';
  static const String validationErrorMessage = 'Validation failed';
}