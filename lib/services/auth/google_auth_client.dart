import 'package:http/http.dart' as http;
import 'package:ptune/exceptions/unauthorized_exception.dart';
import 'package:ptune/services/auth/auth_gateway.dart';
import 'package:ptune/utils/logger.dart';

/// AuthService からトークンを取得して Authorization ヘッダーを付加する HTTP クライアント
class GoogleAuthClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthGateway _authGateway;

  GoogleAuthClient(this._authGateway);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _authGateway.getAccessToken();
    if (token == null) {
      logger.e('[GoogleAuthClient] No access token available.');
      throw UnauthorizedException('No access token available.');
    }
    logger.d('[GoogleAuthClient] Using token: ${token.substring(0, 10)}...');

    request.headers['Authorization'] = 'Bearer $token';
    logger.d('[GoogleAuthClient] Sending ${request.method} ${request.url}');

    final response = await _inner.send(request);

    // 401 → トークンリフレッシュ → 再送
    if (response.statusCode == 401) {
      logger.w('[GoogleAuthClient] Token expired (401) for ${request.url}');
      await _authGateway.refreshToken();
      final retryToken = await _authGateway.getAccessToken(forceRefresh: true);
      if (retryToken == null) {
        logger.e('[GoogleAuthClient] Retry token is null');
        throw UnrecoverableAuthException('Token refresh failed.');
      }

      logger.d(
          '[GoogleAuthClient] Retrying with token: ${retryToken.substring(0, 10)}...');
      final retryRequest = _cloneRequest(request, retryToken);
      final retryResponse = await _inner.send(retryRequest);

      if (retryResponse.statusCode == 401) {
        logger.e('[GoogleAuthClient] Retry failed: still unauthorized');
        throw UnrecoverableAuthException('Access token expired after retry.');
      }
      return retryResponse;
    }

    // 401 以外はそのまま返す (RemoteTaskService 側で解釈)
    return response;
  }

  http.BaseRequest _cloneRequest(http.BaseRequest request, String token) {
    final newRequest = http.Request(request.method, request.url)
      ..headers.addAll(request.headers)
      ..headers['Authorization'] = 'Bearer $token';

    if (request is http.Request) {
      newRequest.bodyBytes = request.bodyBytes;
    }
    return newRequest;
  }
}
