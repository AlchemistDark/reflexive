enum LlmProvider {
  openRouter('OpenRouter', 'https://openrouter.ai/api/v1', 'openrouter/auto'),
  google('Google AI Studio (Gemini)', 'https://generativelanguage.googleapis.com/v1beta/openai', 'gemini-3.5-flash'),
  openai('OpenAI', 'https://api.openai.com/v1', 'gpt-4o'),
  custom('Custom', '', '');

  final String displayName;
  final String defaultBaseUrl;
  final String defaultModel;

  const LlmProvider(this.displayName, this.defaultBaseUrl, this.defaultModel);
}
