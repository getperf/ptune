# Android ビルド手順（準備中）

このページでは、ptune の Android 向けビルド手順を公開予定です。

- Flutter セットアップ
- デバッグビルド
- リリースビルド（Play Store 用）

正式なリリース準備が整い次第、詳細な手順と設定例を追加します。


## 1. Windows 11 初期セットアップ

### 1-1. 必須ランタイム

* **PowerShell 7 最新版（推奨）**
* **Git for Windows**
* **7-Zip**

---

## 2. Flutter SDK の導入（Stable 最新版）

### 2-1. Flutter SDK をインストール

```
https://docs.flutter.dev/get-started/install/windows
```

* ZIP をダウンロードして
  `C:\src\flutter` などに展開

### 2-2. PATH 追加

```
C:\src\flutter\bin
```

### 2-3. flutter doctor 実行

```powershell
flutter doctor
```

---

## 3. Android Studio の導入（Flutter 開発で必須）

### 3-1. Android Studio 最新版をインストール

```
https://developer.android.com/studio
```

### 3-2. 必須コンポーネント

* Android SDK
* Android SDK Platform-Tools
* Android SDK Build-Tools
* Android Emulator
* Android System Images（最新の Pixel 用）

### 3-3. Flutter プラグイン有効化

* Flutter
* Dart

### 3-4. Android ライセンス承諾

```powershell
flutter doctor --android-licenses
```

---

## 4. Visual Studio（.NET + C++）の導入（Windows デスクトップビルド用）

ptune は **Firebase (windows 向け auth)** や **window_manager**, **path_provider** を使うため
**C++ ビルドツールが必須**。

### 4-1. Visual Studio 2022 (Community) をインストール

### 4-2. 必須ワークロード

✔ **C++ デスクトップ開発**（必須）
✔ **Windows 10/11 SDK**（必須）
✔ **MSVC v143 ツールセット**（必須）

Firebase Windows 認証で必要になるため、C++ が欠けていると下記エラーが出ます：

```
Exception: Visual Studio build tools not found
Exception: MSVC toolchain missing
```

---

## 5. Android & iOS（Google OAuth / Firebase）の設定

ptune は 2 モードを持つ：

* **デモモード（Google OAuth なし）**
* **Google Tasks + OAuth モード**

まず Firebase 関連の導入が必要。

---

## 6. Firebase CLI & flutterfire 設定

### 6-1. Firebase CLI をインストール

```
npm install -g firebase-tools
```

### 6-2. FlutterFire CLI をインストール

```
dart pub global activate flutterfire_cli
```

### 6-3. Firebase プロジェクト設定（Android / Web 対応）

```
flutterfire configure
```

選択：

* Android
* Web（Google Tasks 米モードで使用）
* macOS / Windows は任意

Firebase Auth を ptune で使用するため、
**Android SHA-1/256 fingerprint 登録を Firebase Console に追加**。

---

## 7. Google OAuth 設定（ptune の AUTH_PROVIDER=google 用）

Google Cloud Console で OAuth クライアントを作成。

### 7-1. 必要な認証情報

| プラットフォーム | 必須設定                                  |
| -------- | ------------------------------------- |
| Android  | SHA-1, SHA-256 登録必須                   |
| Web      | `http://localhost` と Firebase Hosting |
| Windows  | ループバック `http://127.0.0.1:{port}` 許可   |

### 7-2. 取得する値

* GOOGLE_CLIENT_ID
* GOOGLE_CLIENT_SECRET（Web アプリの場合のみ）

### 7-3. ptune/.env 形式

```
USE_DEMO_SERVICE=false
AUTH_PROVIDER=google
GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=xxxx
```

---

## 8. Windows ローカルの .env でモード切替

### デモモード

```
USE_DEMO_SERVICE=true
```

### Google OAuth モード

```
USE_DEMO_SERVICE=false
AUTH_PROVIDER=google
GOOGLE_CLIENT_ID={ID}
GOOGLE_CLIENT_SECRET={SECRET}
```

ptune の依存関係は **flutter_dotenv**。

---

## 9. ptune の依存パッケージが要求する Windows 個別構成

### 9-1. path_provider

→ Windows の `AppData\Roaming\` or `%LOCALAPPDATA%/ptune/` を使用
→ Visual Studio C++ が必須

### 9-2. window_manager

→ Windows Runner の C++ ビルド必須

### 9-3. firebase_core / firebase_auth (Windows)

→ **msvc_runtime**、**Windows SDK**、**C++/WinRT** パッケージが必要
→ Visual Studio の C++ デスクトップ開発で全て揃う

### 9-4. google_sign_in (Windows)

→ Edge WebView2 が必要
（Windows 11 標準で入っている）

---

## 10. ptune のビルド / 実行

### 初回のみ

```powershell
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### デモモード実行

```powershell
flutter run -d windows
```

.env

```
USE_DEMO_SERVICE=true
```

### Google OAuth 実行

```powershell
flutter run -d windows
```

.env

```
USE_DEMO_SERVICE=false
AUTH_PROVIDER=google
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
```

---

## 11. Android 実機デバッグ

USB デバッグを有効化後：

```powershell
flutter run -d device
```

