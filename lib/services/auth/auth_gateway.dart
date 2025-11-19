/// 認証手段に依存しない共通インターフェース（Firebase/Google OAuth両対応）
abstract class AuthGateway {
  // 認証フローを開始（同意画面 → トークン保存まで）
  Future<void> signIn();

  // サインアウト（トークン削除、ログアウト）
  Future<void> signOut();

  // 現在サインイン済みか（トークン保持状態の簡易チェック）
  Future<bool> isAuthenticated();

  // アクセストークンの取得（Google Tasks API等に利用）
  Future<String?> getAccessToken({bool forceRefresh = false});

  // トークンの有効期限が切れていた場合のリフレッシュ処理
  Future<void> refreshToken();

  // トークンの有効期限（ユーザ表示用やリフレッシュ判定用）
  Future<DateTime?> getTokenExpiry();

  // 現在のユーザのメールアドレス（UI表示用）
  Future<String?> getUserEmail();

  // 状態フラグとしての「サインイン済み」判定（キャッシュ含む）
  bool get isSignedIn;
}
