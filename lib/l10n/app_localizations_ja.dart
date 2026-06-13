// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'リフレクティブ・エージェント';

  @override
  String get settings => '設定';

  @override
  String get general => '全般';

  @override
  String get prompts => 'プロンプト';

  @override
  String iteration(int count) {
    return '反復: $count';
  }

  @override
  String remaining(int seconds) {
    return '残り: $seconds秒';
  }

  @override
  String get critic => '批評家:';

  @override
  String get generatorDraft => 'ジェネレーター (ドラフト):';

  @override
  String get stoppingCriteria => '停止基準';

  @override
  String get maxDuration => '最大時間 (秒)';

  @override
  String get maxIterations => '最大反復回数';

  @override
  String get requestDelay => 'リクエスト遅延 (ミリ秒)';

  @override
  String get requestDelaySubtitle => 'レート制限を避けるためのAPI呼び出し間の遅延';

  @override
  String get stopIfNoIssues => '問題がなければ停止';

  @override
  String get stopIfNoIssuesSubtitle => '批評家が欠陥を見つけなかった場合に早期終了';

  @override
  String get reflectionStrategy => 'リフレクション戦略';

  @override
  String get llmConfiguration => 'LLM設定';

  @override
  String get provider => 'プロバイダー';

  @override
  String get apiKey => 'APIキー';

  @override
  String get baseUrl => 'ベースURL';

  @override
  String get modelName => 'モデル名';

  @override
  String get modelNameHelper =>
      'プロバイダー推奨モデルを使用するには \"auto\" または \"default\" と入力';

  @override
  String get resetToDefault => 'デフォルトにリセット';

  @override
  String get resetToProviderDefault => 'プロバイダーのデフォルトにリセット';

  @override
  String get systemArchitecture => 'システムアーキテクチャ';

  @override
  String get systemArchitectureHelper => 'エージェントへの一般指示';

  @override
  String get mathFormatting => '数学の書式設定';

  @override
  String get mathFormattingHelper => 'LaTeX出力の指示';

  @override
  String get generatorRole => 'ジェネレーターの役割';

  @override
  String get generatorRoleHelper => '最初のドラフトを作成するためのプロンプト';

  @override
  String get criticRole => '批評家の役割 (標準)';

  @override
  String get criticRoleHelper => '標準的な自己レビューのプロンプト';

  @override
  String get devilsAdvocateRole => '悪魔の代弁者の役割';

  @override
  String get devilsAdvocateRoleHelper => '積極的な批判のためのプロンプト';

  @override
  String get editorRole => 'エディターの役割';

  @override
  String get editorRoleHelper => '最終的な仕上げ段階のプロンプト';

  @override
  String get exportPrompts => 'プロンプトを書き出す';

  @override
  String get importPrompts => 'プロンプトを読み込む';

  @override
  String get exportSuccess => 'プロンプトをクリップボードにコピーしました';

  @override
  String get importSuccess => 'プロンプトの読み込みに成功しました';

  @override
  String get importError => '読み込みに失敗しました：無効な形式です';

  @override
  String get useInternet => 'インターネット検索を有効にする';

  @override
  String get useInternetSubtitle =>
      'プロバイダーがサポートしている場合、最新情報を取得するためにモデルがウェブにアクセスすることを許可します';
}
