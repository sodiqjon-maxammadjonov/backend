import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../constants/api_constants.dart';
import '../security/jwt_service.dart';
import '../errors/exceptions.dart';

Middleware authMiddleware(JwtService jwtService, {List<String> excludedPaths = const []}) {
  return (Handler innerHandler) {
    return (Request request) async {
      // Skip authentication for excluded paths
      if (excludedPaths.any((path) => request.url.path.startsWith(path))) {
        return await innerHandler(request);
      }

      final authHeader = request.headers[ApiConstants.authorizationHeader];

      if (authHeader == null || !authHeader.startsWith(ApiConstants.bearerPrefix)) {
        throw UnauthorizedException('Missing or invalid authorization header');
      }

      final token = authHeader.substring(ApiConstants.bearerPrefix.length);

      try {
        final payload = jwtService.verifyToken(token);

        // Add user info to request context
        final updatedRequest = request.change(context: {
          ...request.context,
          'user_id': payload['user_id'],
          'user_email': payload['email'],
          'token_exp': payload['exp'],
        });

        return await innerHandler(updatedRequest);
      } catch (e) {
        throw UnauthorizedException('Invalid or expired token');
      }
    };
  };
}
