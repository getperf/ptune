# タイマー通知設定UI

2026-10-10: B案の設定UI・保存・OS権限操作を実装した段階。
タイマーイベントへの通知発行・予約・取消はまだ接続していない。
画面の「利用可能」は権限条件が揃った状態を示し、時計への到達確認ではない。

検証: 変更ファイルの静的解析と保存・UIテスト4件が通過。
AndroidビルドツールをGradle 8.14.3 / AGP 8.11.1 / Kotlin 2.2.20へ更新し、
`flutter build apk --debug --no-pub` が成功した。iOSビルドと端末上の設定操作は未確認。

## 表示と状態

- 自動で作業開始を通知、作業終了を通知の2スイッチ。初期値はOFF。
- 自動モードOFF時は開始スイッチを操作不可にし、保存値を保持する。
- 通知の利用状態は1行。タップするとOS通知・必要なAndroid端末での終了予約権限をシート表示する。
- 開始のみ有効なら終了予約権限の不足を要設定にしない。
- 両方とも実効無効なら未使用。読込失敗・確認失敗を未許可と区別する。
- OS設定からの復帰時と設定画面を開いたときに権限を再取得する。
- 既存バイブ通知をスマホ本体の振動へ改名。設定画面全体をスクロール可能にする。
- 未対応プラットフォームでは対象外と表示し、スイッチを操作不可にする。

## 責務

| 配置 | 責務 |
|---|---|
| views/settings_view.dart | 全体の並びとスクロール |
| views/settings/timer_notification_section.dart | スイッチと状態1行、画面復帰の検知 |
| views/settings/notification_permission_sheet.dart | 権限詳細・操作ボタン |
| controllers/setting_controller.dart | 操作窓口 |
| states/notification_settings_provider.dart | 設定読込・保存状態 |
| states/notification_permission_provider.dart | OS権限の再取得 |
| services/notification_prefs_service.dart | 2項目を1つのJSON値として保存 |
| services/os_notification_service.dart | ネイティブ権限操作の入口 |
| Android MainActivity / iOS AppDelegate | OS権限APIと設定画面起動 |

## 後続の通知接続

- 通知対象は作業の時間満了と、自動遷移での作業開始。
- 手動開始・再開・停止・リセット、止め忘れ防止による停止は追加通知を出さない。
- 自動モード中の手動開始と自動遷移による開始を区別する。
- 終了通知OFF、一時停止、停止、リセット時の予約取消、再開時の再予約を実装する。
- 時間満了通知とアプリ内完了処理の二重発行を防ぐ。
- タスク保存・リモート同期を通知の成立条件にしない。
- 終了タイトルは短い休憩(5分)／長い休憩(15分)を予定から生成する。
- 止め忘れ防止で休憩をスキップする回のタイトルと、終了予約本文の実績値は設計残件。
- Android通知チャンネル導入時は、アプリ全体の許可に加えて対象チャンネルの有効状態も確認する。
