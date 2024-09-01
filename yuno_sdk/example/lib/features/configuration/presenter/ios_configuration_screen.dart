import 'package:country_code_picker/country_code_picker.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/screen/home.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';

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
    final controller = ref.watch(langNotifier);
    final controllerCountry = ref.watch(contryCodeNotifier);
    final reader = ref.read(contryCodeNotifier.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
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
                  controller.when(
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
                    title: Row(
                      children: [
                        CountryCodePicker(
                          padding: EdgeInsets.zero,
                          initialSelection: controllerCountry?.code,
                          onChanged: (value) => reader.changeContryCode(value),
                        ),
                        const Text('Country'),
                      ],
                    ),
                    leading: const Icon(Icons.location_on),
                    onTap: () {},
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
                      final __ = ref.refresh(appearanceNotifier);
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
