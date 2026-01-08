import 'package:country_code_picker/country_code_picker.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/presenter/screen/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langAsync = ref.watch(langNotifier);
    
    return langAsync.when(
      data: (lang) {
        // Determinar el locale basado en el idioma
        Locale locale;
        TextDirection textDirection;
        
        switch (lang ?? YunoLanguage.en) {
          case YunoLanguage.ar:
            locale = const Locale('ar');
            textDirection = TextDirection.rtl;
            break;
          case YunoLanguage.es:
            locale = const Locale('es');
            textDirection = TextDirection.ltr;
            break;
          case YunoLanguage.pt:
            locale = const Locale('pt');
            textDirection = TextDirection.ltr;
            break;
          case YunoLanguage.id:
            locale = const Locale('id');
            textDirection = TextDirection.ltr;
            break;
          case YunoLanguage.th:
            locale = const Locale('th');
            textDirection = TextDirection.ltr;
            break;
          case YunoLanguage.ms:
            locale = const Locale('ms');
            textDirection = TextDirection.ltr;
            break;
          case YunoLanguage.en:
          default:
            locale = const Locale('en');
            textDirection = TextDirection.ltr;
            break;
        }
        
        return MaterialApp(
          locale: locale,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
          ),
          // Configurar la dirección del texto
          builder: (context, child) {
            return Directionality(
              textDirection: textDirection,
              child: child!,
            );
          },
          home: const HomeScreen(),
          localizationsDelegates: const [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('pt'),
            Locale('ar'),
            Locale('id'),
            Locale('th'),
            Locale('ms'),
          ],
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
