import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import '../errors/exceptions.dart';
import '../constants/app_constants.dart';

class JwtService {
  final DotEnv _env;
  late final String _secretKey;
  late final Duration _accessTokenExpiry;
  late final Duration _refreshTokenExpiry;

  JwtService(this._env) {
    _secretKey = _env['JWT_SECRET'] ?? _throwMissingSecret();
    _accessTokenExpiry = _parseDuration(_env['JWT_EXPIRES_IN'] ?? '24h');
    _refreshTokenExpiry = _parseDuration(_env['JWT_REFRESH_EXPIRES_IN'] ?? '7d');
  }

  String _throwMissingSecret() {
    throw ConfigurationException('JWT_SECRET environment variable is required');
  }

  Duration _parseDuration(String duration) {
    final regex = RegExp(r'^(\d+)([hmsd])$');
    final match = regex.firstMatch(duration.toLowerCase());

    if (match == null) {
      throw ConfigurationException('Invalid duration format: $duration');
    }

    final value = int.parse(match.group(1)!);
    final unit = match.group(2)!;

    switch (unit) {
      case 'h':
        return Duration(hours: value);
      case 'm':
        return Duration(minutes: value);
      case 's':
        return Duration(seconds: value);
      case 'd':
        return Duration(days: value);
      default:
        throw ConfigurationException('Unsupported duration unit: $unit');
    }
  }

  String generateAccessToken(String userId, String email) {
    final jwt = JWT({
      'user_id': userId,
      'email': email,
      'type': 'access',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(_accessTokenExpiry).millisecondsSinceEpoch ~/ 1000,
    });

    return jwt.sign(SecretKey(_secretKey));
  }

  String generateRefreshToken(String userId) {
    final jwt = JWT({
      'user_id': userId,
      'type': 'refresh',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(_refreshTokenExpiry).millisecondsSinceEpoch ~/ 1000,
    });

    return jwt.sign(SecretKey(_secretKey));
  }

  Map<String, dynamic> verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      return jwt.payload;
    } on JWTExpiredException {
      throw UnauthorizedException('Token has expired');
    } on JWTException catch (e) {
      throw UnauthorizedException('Invalid token: ${e.message}');
    }
  }

  bool isTokenExpired(String token) {
    try {
      verifyToken(token);
      return false;
    } on UnauthorizedException {
      return true;
    }
  }

  String? getUserIdFromToken(String token) {
    try {
      final payload = verifyToken(token);
      return payload['user_id'];
    } catch (e) {
      return null;
    }
  }
}
