import 'package:country_code_picker/country_code_picker.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/screen/home.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class IOSConfigurationScreen extends StatelessWidget {
  const IOSConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuration',
        ),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: const DefaultConfiguration(),
    );
  }
}

class DefaultConfiguration extends ConsumerWidget {
  const DefaultConfiguration({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langController = ref.watch(langNotifier);
    final cardFlowController = ref.watch(cardFlowNotifier);
    final controllerNotifier = ref.watch(countryCodeFuture);
    final contryController = ref.watch(contryCodeNotifier.notifier);
    final saveCardController = ref.watch(saveCardNotifier);
    final dynamicSDKController = ref.watch(dynamicSDKNotifier);
    final keepLoaderController = ref.watch(keepLoaderNotifier);
    final cardFormDeployedController = ref.watch(cardFormDeployedNotifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('General'),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: Row(
                      children: [
                        CountryCodePicker(
                          padding: EdgeInsets.zero,
                          initialSelection: controllerNotifier.value ?? "GT",
                          onChanged: (value) =>
                              contryController.changeContryCode(value),
                        ),
                        const Text('Country'),
                      ],
                    ),
                    leading: const Icon(Icons.location_on),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          //-----------------------------------------------------------
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('SDK Settings'),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  langController.when(
                    data: (data) => ListTile(
                      minVerticalPadding: 10,
                      minTileHeight: 10,
                      title: Text('Language - ${data?.rawValue ?? 'N/A'}'),
                      leading: const Icon(Icons.language),
                      onTap: () async {
                        final lang = await YunoDiaglos.show(context: context);

                        if (lang != null) {
                          ref.read(providerStorage).write(
                              key: Keys.language.name, value: lang.rawValue);
                          final _ = ref.refresh(yunoProvider);
                          ref.invalidate(langNotifier);
                        }
                      },
                    ),
                    error: (err, stk) => ErrorWidget(err),
                    loading: () => const CircularProgressIndicator(),
                  ),
                  const Divider(
                    thickness: 0.5,
                    height: 0,
                  ),
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Dynamic SDK'),
                    leading: const Icon(Icons.dynamic_feed_rounded),
                    trailing: CupertinoSwitch(
                      value: dynamicSDKController.value ?? false,
                      onChanged: (value) async {
                        await ref.read(providerStorage).writeBool(
                              key: Keys.isDynamicViewEnable.name,
                              value: value,
                            );
                        ref.invalidate(dynamicSDKNotifier);
                        ref.invalidate(yunoProvider);
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    height: 0,
                  ),
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Keep Loader'),
                    leading: const Icon(Icons.back_hand_outlined),
                    trailing: CupertinoSwitch(
                      value: keepLoaderController.value ?? false,
                      onChanged: (value) async {
                        await ref.read(providerStorage).writeBool(
                              key: Keys.keepLoader.name,
                              value: value,
                            );
                        ref.invalidate(keepLoaderNotifier);
                        ref.invalidate(yunoProvider);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          //-----------------------------------------------------------
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('CARD Settings'),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: cardFlowController.when(
                        data: (data) => Text(
                            'Mode - ${data == CardFlow.oneStep ? 'ONE STEP' : 'STEP BY STEP'}'),
                        error: (err, stck) => ErrorWidget(err),
                        loading: () => const CircularProgressIndicator()),
                    leading: const Icon(Icons.credit_card),
                    onTap: () async {
                      final cardFlow =
                          await YunoDiaglos.showCardStep(context: context);
                      if (cardFlow != null) {
                        await ref.read(providerStorage).write(
                              key: Keys.cardFlow.name,
                              value: cardFlow.name,
                            );
                        ref.invalidate(cardFlowNotifier);
                        ref.invalidate(yunoProvider);
                      }
                    },
                  ),
                  const Divider(
                    thickness: 0.5,
                    height: 0,
                  ),
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Card Unfolded'),
                    leading: const Icon(Icons.movie_creation_outlined),
                    trailing: CupertinoSwitch(
                      value: cardFormDeployedController.value ?? false,
                      onChanged: (value) async {
                        await ref.read(providerStorage).writeBool(
                              key: Keys.cardFormDeployed.name,
                              value: value,
                            );
                        ref.invalidate(cardFormDeployedNotifier);
                        ref.invalidate(yunoProvider);
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    height: 0,
                  ),
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Save Card'),
                    leading: const Icon(Icons.credit_score),
                    trailing: CupertinoSwitch(
                      value: saveCardController.value ?? false,
                      onChanged: (value) async {
                        await ref.read(providerStorage).writeBool(
                              key: Keys.saveCardEnable.name,
                              value: value,
                            );
                        ref.invalidate(saveCardNotifier);
                        ref.invalidate(yunoProvider);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          //-----------------------------------------------------------
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Appearence'),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Font'),
                    leading: const Icon(Icons.font_download),
                    onTap: () async {
                      await ShowBottomDialog.showFontsList(context);
                      ref.invalidate(appearanceNotifier);
                      final _ = ref.refresh(yunoProvider);
                    },
                  ),
                  const Divider(
                    thickness: 0.5,
                    height: 0,
                  ),
                  ListTile(
                    minVerticalPadding: 10,
                    minTileHeight: 10,
                    title: const Text('Select Colors'),
                    leading: const Icon(Icons.color_lens),
                    onTap: () async {
                      await ShowBottomDialog.showAppearence(context);
                      ref.invalidate(appearanceNotifier);
                      final _ = ref.refresh(yunoProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YunoDiaglos {
  static Future<CardFlow?> showCardStep({
    required BuildContext context,
  }) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Card Flow"),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, CardFlow.values[index]),
                      child: Center(
                        child: Text(CardFlow.values[index].name),
                      ),
                    );
                  },
                  itemCount: CardFlow.values.length,
                ),
              )
            ],
          );
        },
      );
  static Future<YunoLanguage?> show({
    required BuildContext context,
  }) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select a language"),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, YunoLanguage.values[index]),
                      child: Center(
                        child: Text(YunoLanguage.values[index].rawValue),
                      ),
                    );
                  },
                  itemCount: YunoLanguage.values.length,
                ),
              )
            ],
          );
        },
      );

  static Future<Color?> showPickerColor({required BuildContext context}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        Color? color;
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.black,
              onColorChanged: (value) {
                color = value;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop(color);
              },
            ),
          ],
        );
      },
    );
  }
}
