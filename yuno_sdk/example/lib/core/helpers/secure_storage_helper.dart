import 'dart:ui';

import 'package:example/core/feature/credential/domain/entity/credential/credential.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yuno/yuno.dart';

class SecureStorage {
  const SecureStorage({
    required this.storage,
  });
  final SharedPreferences storage;

  Future<void> write({
    required String key,
    required String value,
  }) async {
    await storage.setString(
      key,
      value,
    );
  }

  Future<void> writeInt({
    required String key,
    required int value,
  }) async {
    await storage.setInt(
      key,
      value,
    );
    await storage.reload();
  }

  Future<Color?> getColor({required String key}) async {
    await storage.reload();
    int? colorValue = storage.getInt(key);
    if (colorValue == null) {
      return null;
    }
    return Color(colorValue); // Convert int back to Color
  }

  Future<String> read({
    required String key,
  }) async {
    final data = storage.get(
          key,
        ) ??
        '';

    return data as String;
  }

  Future<void> removeAll() async {
    await storage.clear();
  }

  Future<YunoLanguage?> getLang({
    required String key,
  }) async {
    await storage.reload();
    final str = await read(key: key);

    final reuslt =
        YunoLanguage.values.where((lang) => lang.rawValue == str).firstOrNull;
    return reuslt;
  }
}

final credentialNotifier = FutureProvider<Credential>(
  (ref) async {
    final apiKey = await ref.watch(providerStorage).read(
          key: Keys.apiKey.name,
        );
    final countryCode =
        await ref.watch(providerStorage).read(key: Keys.countryCode.name);
    final alias = await ref.watch(providerStorage).read(
          key: Keys.alias.name,
        );

    return Credential(
      apiKey: apiKey,
      countryCode: countryCode,
      alias: alias,
    );
  },
);

final appearanceNotifier = FutureProvider<Appearance>(
  (ref) async {
    final buttonBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.buttonBackgrounColor.name);
    final buttonBorderBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.buttonBorderBackgrounColor.name);
    final buttonTitleBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.buttonTitleBackgrounColor.name);
//--------------------------------------------------------------------
    final secondaryButtonBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.secondaryButtonBackgrounColor.name);
    final secondaryButtonBorderBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.secondaryButtonBorderBackgrounColor.name);
    final secondaryButtonTitleBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.secondaryButtonTitleBackgrounColor.name);
//-------------------------------------------------------------------

    final disableButtonBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.disableButtonBackgrounColor.name);

    final disableButtonTitleBackgrounColor = await ref
        .watch(providerStorage)
        .getColor(key: Keys.disableButtonTitleBackgrounColor.name);

//-------------------------------------------------------------------
    final checkboxColor =
        await ref.watch(providerStorage).getColor(key: Keys.checkboxColor.name);

    return Appearance(
      buttonBackgrounColor: buttonBackgrounColor,
      buttonBorderBackgrounColor: buttonBorderBackgrounColor,
      buttonTitleBackgrounColor: buttonTitleBackgrounColor,
      secondaryButtonBackgrounColor: secondaryButtonBackgrounColor,
      secondaryButtonBorderBackgrounColor: secondaryButtonBorderBackgrounColor,
      secondaryButtonTitleBackgrounColor: secondaryButtonTitleBackgrounColor,
      disableButtonBackgrounColor: disableButtonBackgrounColor,
      disableButtonTitleBackgrounColor: disableButtonTitleBackgrounColor,
      checkboxColor: checkboxColor,
    );
  },
);

final langNotifier = FutureProvider<YunoLanguage?>(
  (ref) async {
    return await ref.watch(providerStorage).getLang(key: Keys.language.name);
  },
);

final providerStorage = Provider<SecureStorage>(
  (ref) => SecureStorage(
    storage: ref.read(sharedPreferencesProvider),
  ),
);

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
