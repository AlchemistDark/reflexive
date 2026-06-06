import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflexive/data/repositories/dio_llm_repository.dart';
import 'package:reflexive/data/repositories/shared_prefs_settings_repository.dart';
import 'package:reflexive/domain/repositories/llm_repository.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';
import 'package:reflexive/domain/usecases/reflect_agent_usecase.dart';
import 'package:reflexive/presentation/bloc/chat_bloc.dart';

/// Service Locator instance from GetIt.
final sl = GetIt.instance;

/// Initializes all dependencies for the application.
/// 
/// This includes BLoCs, Use Cases, Repositories, and External libraries.
Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => ChatBloc(
      reflectAgentUseCase: sl(),
      settingsRepository: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => ReflectAgentUseCase(llmRepository: sl()));

  // Repositories
  sl.registerLazySingleton<LlmRepository>(
    () => DioLlmRepository(
      dio: sl(),
      apiKey: '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',
      baseUrl: 'https://openrouter.ai/api/v1',
      model: 'openrouter/auto',
    ),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SharedPrefsSettingsRepository(sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
