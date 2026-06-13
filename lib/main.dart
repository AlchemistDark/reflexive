import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reflexive/core/di/injection_container.dart' as di;
import 'package:reflexive/presentation/bloc/chat_bloc.dart';
import 'package:reflexive/presentation/screens/chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The entry point of the Reflexive Agent application.
void main() async {
  // Ensure that plugin services are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection.
  await di.init();
  
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('zh'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('pt'),
        Locale('ja'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // ChatScreen is wrapped with BlocProvider for ChatBloc at the top level
      // to ensure it is accessible throughout the main screen.
      home: BlocProvider(
        create: (_) => di.sl<ChatBloc>(),
        child: const ChatScreen(),
      ),
    );
  }
}
