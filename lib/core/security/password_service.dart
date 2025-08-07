import 'package:bcrypt/bcrypt.dart';
import 'package:dotenv/dotenv.dart';
import '../constants/app_constants.dart';

class PasswordService {
  final DotEnv _env;
  late final int _saltRounds;

  PasswordService(this._env) {
    _saltRounds = int.tryParse(_env['BCRYPT_ROUNDS'] ?? '') ?? AppConstants.defaultBcryptRounds;
  }

  String hashPassword(String password) {
    _validatePassword(password);
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: _saltRounds));
  }

  bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  void _validatePassword(String password) {
    if (password.length < AppConstants.minPasswordLength) {
      throw ArgumentError('Password must be at least ${AppConstants.minPasswordLength} characters long');
    }

    if (password.length > AppConstants.maxPasswordLength) {
      throw ArgumentError('Password must not exceed ${AppConstants.maxPasswordLength} characters');
    }

    // Additional password strength validation can be added here
    if (!_hasMinimumStrength(password)) {
      throw ArgumentError('Password must contain at least one uppercase letter, one lowercase letter, and one number');
    }
  }

  bool _hasMinimumStrength(String password) {
    // At least one uppercase, one lowercase, one digit
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }
}
