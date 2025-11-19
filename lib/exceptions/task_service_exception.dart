import 'api_exeption.dart';

class NotFoundException extends ApiException {
  NotFoundException(String message, {String? body})
      : super(404, message, body: body);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message, {String? body})
      : super(403, message, body: body);
}

/// 500 系やネットワーク障害 → notifyUser = false にする
class ServerErrorException extends ApiException {
  ServerErrorException(String message, {String? body})
      : super(500, message, body: body, notifyUser: false);
}
