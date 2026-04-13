import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

final yunoProvider = FutureProvider<void>((ref) async {
  final apiKey = await ref.watch(providerStorage).read(key: Keys.apiKey.name);
  final countryCode = await ref.watch(countryCodeFuture.future);
  final lang = await ref.watch(langNotifier.future);
  final appearance = await ref.watch(appearanceNotifier.future);
  final saveCard = await ref.watch(saveCardNotifier.future);
  final keepLoader = await ref.watch(keepLoaderNotifier.future);

  try {
    if (kDebugMode) {
      debugPrint('QA App -> Initializing Yuno SDK with apiKey: $apiKey, countryCode: $countryCode');
    }
    return await Yuno.init(
      apiKey: apiKey,
      countryCode: countryCode,
      yunoConfig: YunoConfig(
        lang: lang ?? YunoLanguage.en,
        keepLoader: keepLoader,
        saveCardEnable: saveCard,
        appearance: appearance,
      ),
    );
  } catch (e) {
    throw Exception();
  }
});
