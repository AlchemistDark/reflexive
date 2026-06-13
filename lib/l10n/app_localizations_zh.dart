// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '反思代理';

  @override
  String get settings => '设置';

  @override
  String get general => '常规';

  @override
  String get prompts => '提示词';

  @override
  String iteration(int count) {
    return '迭代: $count';
  }

  @override
  String remaining(int seconds) {
    return '剩余时间: $seconds秒';
  }

  @override
  String get critic => '评论员:';

  @override
  String get generatorDraft => '生成器 (草案):';

  @override
  String get stoppingCriteria => '停止标准';

  @override
  String get maxDuration => '最大时长 (秒)';

  @override
  String get maxIterations => '最大迭代次数';

  @override
  String get requestDelay => '请求延迟 (毫秒)';

  @override
  String get requestDelaySubtitle => 'API 调用之间的延迟以避免频率限制';

  @override
  String get stopIfNoIssues => '如果没有问题则停止';

  @override
  String get stopIfNoIssuesSubtitle => '如果评论员未发现缺陷，则提前退出';

  @override
  String get reflectionStrategy => '反思策略';

  @override
  String get llmConfiguration => 'LLM 配置';

  @override
  String get provider => '提供商';

  @override
  String get apiKey => 'API 密钥';

  @override
  String get baseUrl => '基础 URL';

  @override
  String get modelName => '模型名称';

  @override
  String get modelNameHelper => '输入 \"auto\" 或 \"default\" 使用提供商推荐的模型';

  @override
  String get resetToDefault => '重置为默认值';

  @override
  String get resetToProviderDefault => '重置为提供商默认值';

  @override
  String get systemArchitecture => '系统架构';

  @override
  String get systemArchitectureHelper => '代理的一般指令';

  @override
  String get mathFormatting => '数学格式化';

  @override
  String get mathFormattingHelper => 'LaTeX 输出指令';

  @override
  String get generatorRole => '生成器角色';

  @override
  String get generatorRoleHelper => '创建初稿的提示词';

  @override
  String get criticRole => '评论员角色 (标准)';

  @override
  String get criticRoleHelper => '标准自评提示词';

  @override
  String get devilsAdvocateRole => '魔鬼代言人角色';

  @override
  String get devilsAdvocateRoleHelper => '激进批评提示词';

  @override
  String get editorRole => '编辑角色';

  @override
  String get editorRoleHelper => '最后修饰阶段的提示词';

  @override
  String get exportPrompts => '导出提示词';

  @override
  String get importPrompts => '导入提示词';

  @override
  String get exportSuccess => '提示词已复制到剪贴板';

  @override
  String get importSuccess => '提示词导入成功';

  @override
  String get importError => '导入失败：格式无效';

  @override
  String get useInternet => '启用网络搜索';

  @override
  String get useInternetSubtitle => '允许模型访问网络以获取最新信息（如果提供商支持）';
}
