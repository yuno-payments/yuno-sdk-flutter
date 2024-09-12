import 'dart:io';

import 'package:example/core/feature/utils/yuno_dialogs.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class CardSettings extends ConsumerWidget {
  const CardSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardFormDeployedController = ref.watch(cardFormDeployedNotifier);
    final saveCardController = ref.watch(saveCardNotifier);
    final cardFlowController = ref.watch(cardFlowNotifier);
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
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: cardFormDeployedController.value ?? false,
                          onChanged: (value) async =>
                              onCardUnfolded(value: value, ref: ref),
                        )
                      : Switch(
                          value: cardFormDeployedController.value ?? false,
                          onChanged: (value) async =>
                              onCardUnfolded(value: value, ref: ref),
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

  Future<void> onCardUnfolded({
    required bool value,
    required WidgetRef ref,
  }) async {
    await ref.read(providerStorage).writeBool(
          key: Keys.cardFormDeployed.name,
          value: value,
        );
    ref.invalidate(cardFormDeployedNotifier);
    ref.invalidate(yunoProvider);
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
