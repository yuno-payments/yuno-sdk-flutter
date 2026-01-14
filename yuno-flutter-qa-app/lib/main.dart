import 'dart:async';

import 'package:app_links/app_links.dart';
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

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  /// Initializes deep link handling.
  ///
  /// Sets up listeners for incoming deep links and processes them
  /// by calling Yuno.receiveDeeplink() to handle payment-related deeplinks.
  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial link if app was opened via deeplink
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Listen for deeplinks while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (error) {
        // Handle deeplink errors silently
      },
    );
  }

  /// Handles incoming deep links.
  ///
  /// Processes the deeplink URI and forwards it to Yuno SDK
  /// if it matches the payment deeplink scheme.
  ///
  /// Parameters:
  /// - [uri]: The deep link URI received
  void _handleDeepLink(Uri uri) {
    // Only process deeplinks with the yuno scheme
    if (uri.scheme == 'yuno') {
      Yuno.receiveDeeplink(url: uri);
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
