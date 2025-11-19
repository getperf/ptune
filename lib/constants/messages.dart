class SyncMessages {
  static const exportTitle = 'タスクのエクスポート';
  static const exportConfirm = '''
ローカルのタスクを Google Tasks API に上書きします。
オフライン中の変更によって不整合が発生した場合などに使用してください。
この操作を続けますか？''';

  static const importTitle = 'タスクのインポート';
  static const importConfirm = '''
Google Tasks API のタスクをローカルに上書きします。
Obsidian などのツールで作成したタスクを反映する際に使用します。
この操作を続けますか？''';

  static const initTitle = 'タスクリストの初期化';
  static const initConfirm = '''
Google Tasks に Today タスクリストを新規作成します（既存がなければ）。
この操作は最初の一回のみ必要です。
この操作を続けますか？''';
}

class SyncLabels {
  static const initButton = 'タスクリスト初期化';
  static const initNote = 'Google Tasks に Today タスクリストを登録します。初回のみ実行してください。';

  static const importButton = 'タスクを取り込む';
  static const importNote = 'Obsidian などでエクスポートしたタスクを取り込みます。';

  static const exportButton = 'Google Tasks にタスクを反映';
  static const exportNote = 'オフライン操作で不整合がおきた場合にタスクをAPIへ上書きします。';
}
