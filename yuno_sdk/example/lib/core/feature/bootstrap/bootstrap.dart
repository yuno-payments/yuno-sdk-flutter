import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

final yunoProvider = FutureProvider<Yuno>((ref) async {
  final apiKey = await ref.watch(providerStorage).read(key: Keys.apiKey.name);
  final countryCode =
      await ref.watch(providerStorage).read(key: Keys.countryCode.name);
  final lang = await ref.watch(langNotifier.future);
  final cardFlow = await ref.watch(cardFlowNotifier.future);
  final appearance = await ref.watch(appearanceNotifier.future);
  final saveCard = await ref.watch(saveCardNotifier.future);
  final isDynamic = await ref.watch(dynamicSDKNotifier.future);
  final keepLoader = await ref.watch(keepLoaderNotifier.future);
  final cardForm = await ref.watch(cardFormDeployedNotifier.future);

  try {
    final yuno = await Yuno.init(
      apiKey: apiKey,
      countryCode: countryCode,
      yunoConfig: YunoConfig(
        lang: lang ?? YunoLanguage.en,
        cardFlow: cardFlow,
        keepLoader: keepLoader,
        saveCardEnable: saveCard,
        isDynamicViewEnable: isDynamic,
        cardFormDeployed: cardForm,
      ),
      iosConfig: IosConfig(
        appearance: appearance,
      ),
    );
    return yuno;
  } catch (e) {
    throw Exception();
  }
});
