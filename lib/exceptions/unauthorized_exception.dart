import 'package:ptune/exceptions/api_exeption.dart';

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, {String? body})
      : super(401, message, body: body);
}

/// リフレッシュ後も復旧できない場合
class UnrecoverableAuthException extends ApiException {
  UnrecoverableAuthException(String message, {String? body})
      : super(401, message, body: body);
}
