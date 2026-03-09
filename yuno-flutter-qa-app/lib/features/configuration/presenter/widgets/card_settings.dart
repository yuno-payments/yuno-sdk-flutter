import 'dart:io';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardSettings extends ConsumerWidget {
  const CardSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveCardController = ref.watch(saveCardNotifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  title: const Text('Save Card'),
                  leading: const Icon(Icons.credit_score),
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: saveCardController.value ?? false,
                          onChanged: (value) async =>
                              await onToggleSaveCard(value: value, ref: ref),
                        )
                      : Switch(
                          value: saveCardController.value ?? false,
                          onChanged: (value) async =>
                              await onToggleSaveCard(value: value, ref: ref),
                        ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onToggleSaveCard({
    required bool value,
    required WidgetRef ref,
  }) async {
    await ref.read(providerStorage).writeBool(
          key: Keys.saveCardEnable.name,
          value: value,
        );
    ref.invalidate(saveCardNotifier);
    ref.invalidate(yunoProvider);
  }
}
