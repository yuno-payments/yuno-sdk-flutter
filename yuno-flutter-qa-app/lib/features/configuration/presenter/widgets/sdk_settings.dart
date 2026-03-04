import 'dart:io';

import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/feature/utils/yuno_dialogs.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SDKSettings extends ConsumerStatefulWidget {
  const SDKSettings({super.key});

  @override
  ConsumerState<SDKSettings> createState() => _SDKSettingsState();
}

class _SDKSettingsState extends ConsumerState<SDKSettings> {
  final _amountController = TextEditingController(text: '10000');
  final _currencyController = TextEditingController(text: 'COP');
  bool _initialized = false;

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _saveAmount(String value) async {
    await ref.read(providerStorage).write(
          key: Keys.paymentAmount.name,
          value: value,
        );
    ref.invalidate(paymentAmountProvider);
  }

  Future<void> _saveCurrency(String value) async {
    await ref.read(providerStorage).write(
          key: Keys.paymentCurrency.name,
          value: value.toUpperCase(),
        );
    ref.invalidate(paymentCurrencyProvider);
  }

  @override
  Widget build(BuildContext context) {
    final keepLoaderController = ref.watch(keepLoaderNotifier);
    final langController = ref.watch(langNotifier);
    final showPaymentStatus = ref.watch(showPaymentStatusProvider);
    final automaticPayment = ref.watch(automaticPaymentProvider);
    final amount = ref.watch(paymentAmountProvider);
    final currency = ref.watch(paymentCurrencyProvider);

    // Initialize controllers with stored values
    if (!_initialized) {
      amount.whenData((value) {
        _amountController.text = value.toString();
      });
      currency.whenData((value) {
        _currencyController.text = value;
      });
      if (amount.hasValue && currency.hasValue) {
        _initialized = true;
      }
    }

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
                          onChanged: (value) async => await _onToggleKeepLoader(
                            value: value,
                          ),
                        )
                      : Switch(
                          value: keepLoaderController.value ?? false,
                          onChanged: (value) async => await _onToggleKeepLoader(
                            value: value,
                          ),
                        ),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  minTileHeight: 10,
                  title: const Text('Automatic Payment'),
                  leading: const Icon(Icons.payment),
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: automaticPayment.value ?? true,
                          onChanged: (value) async {
                            await ref.watch(providerStorage).writeBool(
                                key: Keys.automaticPayment.name, value: value);
                            ref.invalidate(automaticPaymentProvider);
                          },
                        )
                      : Switch(
                          value: automaticPayment.value ?? true,
                          onChanged: (value) async {
                            await ref.watch(providerStorage).writeBool(
                                key: Keys.automaticPayment.name, value: value);
                            ref.invalidate(automaticPaymentProvider);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onChanged: _saveAmount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _currencyController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: 'Currency',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onChanged: _saveCurrency,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  minTileHeight: 10,
                  title: const Text('Show Status Screen'),
                  leading: const Icon(Icons.check_box),
                  trailing: Platform.isIOS
                      ? CupertinoSwitch(
                          value: showPaymentStatus.value ?? true,
                          onChanged: (value) async {
                            await ref.watch(providerStorage).writeBool(
                                key: Keys.showPaymentStatus.name, value: value);
                            ref.invalidate(showPaymentStatusProvider);
                          },
                        )
                      : Switch(
                          value: showPaymentStatus.value ?? true,
                          onChanged: (value) async {
                            await ref.watch(providerStorage).writeBool(
                                key: Keys.showPaymentStatus.name, value: value);
                            ref.invalidate(showPaymentStatusProvider);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onToggleKeepLoader({
    required bool value,
  }) async {
    await ref.read(providerStorage).writeBool(
          key: Keys.keepLoader.name,
          value: value,
        );
    ref.invalidate(keepLoaderNotifier);
    ref.invalidate(yunoProvider);
  }
}
