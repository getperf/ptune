class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? body;
  final bool notifyUser; // 追加

  ApiException(this.statusCode, this.message,
      {this.body, this.notifyUser = true});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
