import 'dart:io';

import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/feature/utils/yuno_dialogs.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SDKSettings extends ConsumerWidget {
  const SDKSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicSDKController = ref.watch(dynamicSDKNotifier);
    final keepLoaderController = ref.watch(keepLoaderNotifier);
    final langController = ref.watch(langNotifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: dynamicSDKController.value ?? false,
                          onChanged: (value) async =>
                              onToggleDynamicSDK(value: value, ref: ref),
                        )
                      : Switch(
                          value: dynamicSDKController.value ?? false,
                          onChanged: (value) async =>
                              onToggleDynamicSDK(value: value, ref: ref),
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
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: keepLoaderController.value ?? false,
                          onChanged: (value) async => await onToggleKeepLoader(
                            value: value,
                            ref: ref,
                          ),
                        )
                      : Switch(
                          value: keepLoaderController.value ?? false,
                          onChanged: (value) async => await onToggleKeepLoader(
                            value: value,
                            ref: ref,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onToggleDynamicSDK({
    required bool value,
    required WidgetRef ref,
  }) async {
    await ref.read(providerStorage).writeBool(
          key: Keys.isDynamicViewEnable.name,
          value: value,
        );
    ref.invalidate(dynamicSDKNotifier);
    ref.invalidate(yunoProvider);
  }

  Future<void> onToggleKeepLoader({
    required bool value,
    required WidgetRef ref,
  }) async {
    await ref.read(providerStorage).writeBool(
          key: Keys.keepLoader.name,
          value: value,
        );
    ref.invalidate(keepLoaderNotifier);
    ref.invalidate(yunoProvider);
  }
}
