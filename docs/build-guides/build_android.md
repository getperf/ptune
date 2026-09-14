# Android ビルド手順

このページは、ptune の Android 向けビルド手順である。

- Flutter セットアップ → §1〜§9
- デバッグビルド → §10・§11
- リリースビルド（Play Store 用）→ §12

**リリースビルドは §12 にある**（2026-09-14 に追記）。署名・鍵の指紋の登録・`.env` の焼き込み・R8 の扱いはそこを見ること。


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

---

## 12. リリースビルド（Android）

### 12-1. 前提の版

**Flutter 3.47.4 / Dart 3.13.3 に合わせてある**（2026-09-14 に追従）。

| | 値 | 決まり方 |
|---|---|---|
| Flutter / Dart | 3.47.4 / 3.13.3 | |
| Gradle | **8.14.5** | Flutter 3.47.4 の下限が 8.14.0 |
| AGP | **8.11.2** | KGP 2.2.x と組めるのは 8.12 未満まで |
| Kotlin（KGP） | **2.2.21** | Flutter 3.47.4 の下限が 2.2.20 |
| JDK | 21 | |

**この3つは同時にしか動かせない。** Flutter は KGP↔AGP・AGP↔Gradle・KGP↔Gradle の3つの互換表を
同時に見ており、1つだけ上げると弾かれる。版は `android/settings.gradle.kts`（AGP・KGP）と
`android/gradle/wrapper/gradle-wrapper.properties`（Gradle）にある。

ビルド時に「will soon be dropped」の警告が3つ出るが、**error の下限は越えているので通る。**

**`--android-skip-build-dependency-validation` は使わないこと。** 検査を黙らせるだけで、実際に
噛み合わなくなったときに理由が見えなくなる。

### 12-2. 署名の準備

`android/key.properties` を置く。**git 管理外である**（`android/.gitignore`）。

```properties
storeFile=ptune-release-key.jks
storePassword=＜秘密＞
keyAlias=ptune
keyPassword=＜秘密＞
```

keystore は `android/app/ptune-release-key.jks` に置く。`storeFile` は **`android/app/` 起点**で
解決される（`app/build.gradle.kts` の `file(...)`）。

**`key.properties` が無くてもビルドは進む。** `storePassword` などが null のまま release の署名設定が
作られ、**署名の段になって落ちる。** 「鍵が無い」とは言ってくれない。

### 12-3. release 鍵の指紋を登録する

```powershell
keytool -list -v -keystore android/app/ptune-release-key.jks -alias ptune
```

出た **SHA-1 と SHA-256 を、Firebase Console と Google Cloud の OAuth クライアントへ登録する。**

**debug 鍵とは別物である。** 登録していないと、**ビルドもインストールも通り、認可だけが実機で
落ちる。** 切り分けにいちばん時間を取られる形なので、実機へ入れる前に確かめること。

現在の鍵（2026-09-14 実測）:

```
SHA1:   45:4B:03:C8:A4:B5:D2:9C:05:15:F1:09:7F:B8:0F:C6:E3:B6:E1:B9
SHA256: 11:74:A2:7F:52:64:CD:0D:35:0C:C6:C3:14:96:A9:DE:F0:75:80:08:10:BF:B7:91:EF:3E:03:55:69:D7:06:9D
```

### 12-4. 建てる

```powershell
flutter clean                       # 足場を上げた直後は必ず挟む
flutter pub get
flutter build apk --release         # 実機検証用
flutter build appbundle --release   # Play Store 提出用
```

出力。

```text
build\app\outputs\flutter-apk\app-release.apk
build\app\outputs\bundle\release\app-release.aab
```

**`flutter clean` を省かない。** Flutter や Gradle を上げた直後は、古い `build/` に残った assets が
新しい Flutter の複製と衝突して落ちる（2026-09-14 に実際に踏んだ）。

```text
PathExistsException: Cannot copy file to '...\flutter_assets\assets/tasks.json'
(OS Error: 既に存在するファイルを作成することはできません。, errno = 183)
```

### 12-5. 署名を確かめる

**「建った」と「release 鍵で署名された」は別である。**

```powershell
$apksigner = "$env:LOCALAPPDATA\Android\Sdk\build-tools\36.0.0\apksigner.bat"
& $apksigner verify --print-certs build\app\outputs\flutter-apk\app-release.apk
```

出た `Signer #1 certificate SHA-1 digest` が **12-3 の SHA-1 と一致すること**を見る。
debug 鍵で署名されていたらここで分かる。

### 12-6. 実機へ入れる

```powershell
adb devices
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

### 12-7. `.env` は版に焼かれる

`USE_DEMO_SERVICE` / `AUTH_PROVIDER` / `GOOGLE_CLIENT_ID` は assets の `.env` から読まれ、
**ビルドした時点の内容が APK に入る**（`flutter_dotenv`）。デモモードのまま出さないよう、
**建てる前に `.env` を確認すること。**

### 12-8. release は R8 を通していない

`android/app/build.gradle.kts` の release は `isMinifyEnabled = false` /
`isShrinkResources = false` である。難読化も未使用リソースの削除もしない。

**Play Store へ出す前に、通すかどうかを決めること。** 通すなら Firebase と Google Sign-In の
keep 規則が要る（通した直後に認可だけが落ちる形になりやすい）。
