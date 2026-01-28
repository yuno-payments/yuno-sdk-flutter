import 'package:country_code_picker/country_code_picker.dart';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/feature/credential/domain/entity/credential/credential.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _aliasController = TextEditingController();
  final _apiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            YunoInput(
              title: 'Alias',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an alias';
                }
                return null;
              },
              controller: _aliasController,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            YunoInput(
              title: 'Public Api Key',
              controller: _apiController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your api key';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer(
              builder: (context, ref, child) {
                final controller = ref.watch(contryCodeNotifier);
                final reader = ref.read(contryCodeNotifier.notifier);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: CountryCodePicker(
                          initialSelection: controller?.code ?? 'CO',
                          onChanged: (value) => reader.changeContryCode(value),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: TextEditingController(
                              text:
                                  '${controller?.name ?? ''}  ${controller?.code ?? ''}'),
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Choose a country'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer(builder: (context, ref, widget) {
              final storage = ref.read(providerStorage);
              return ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(
                    Colors.black,
                  ),
                ),
                onPressed: () async =>
                    await safeMethod(storage: storage, ref: ref),
                child: const SizedBox(
                  width: 270,
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> safeMethod({
    required SecureStorage storage,
    required WidgetRef ref,
  }) async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get country code or use default
    var contryCode = ref.read(contryCodeNotifier);
    final countryCodeString = contryCode?.code ?? 'CO';

    try {
      final newCredential = Credential(
        alias: _aliasController.text.trim(),
        apiKey: _apiController.text.trim(),
        countryCode: countryCodeString,
      );

      // Get existing credentials
      final existingCredentials = await storage.getCredentials();

      // Check if alias already exists
      final existingIndex = existingCredentials.indexWhere(
        (cred) => cred.alias == newCredential.alias,
      );

      List<Credential> updatedCredentials;
      if (existingIndex >= 0) {
        // Update existing credential
        updatedCredentials = List<Credential>.from(existingCredentials);
        updatedCredentials[existingIndex] = newCredential;
      } else {
        // Add new credential
        updatedCredentials = [...existingCredentials, newCredential];
      }

      // Save updated list
      await storage.saveCredentials(updatedCredentials);

      // Set as current credential
      await storage.setCurrentCredential(newCredential);

      // Clear form
      _formKey.currentState!.reset();
      _aliasController.clear();
      _apiController.clear();

      if (!mounted) return;

      // Close the bottom sheet first
      Navigator.of(context).pop();

      // Then refresh the provider after navigation is complete
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        ref.refresh(credentialNotifier.future);
        ref.refresh(credentialsListNotifier.future);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving credential: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

typedef Validator = String? Function(String?)?;
typedef OnChange = void Function(String?)?;

class YunoInput extends StatelessWidget {
  const YunoInput({
    super.key,
    this.onChange,
    this.onPaste,
    required this.title,
    required this.validator,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;
  final Validator validator;
  final OnChange? onChange;
  final VoidCallback? onPaste;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _controller,
            onChanged: onChange,
            validator: validator,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            var cdata = await Clipboard.getData(Clipboard.kTextPlain);
            _controller.text = cdata?.text ?? '';
            if (onPaste != null) {
              onPaste!();
            }
          },
          icon: const Icon(
            Icons.paste_sharp,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: _controller.text));
          },
          icon: const Icon(
            Icons.copy,
          ),
        ),
      ],
    );
  }
}

final contryCodeNotifier = NotifierProvider<CountryCodeNotiifer, CountryCode?>(
    CountryCodeNotiifer.new);

class CountryCodeNotiifer extends Notifier<CountryCode?> {
  @override
  CountryCode? build() => null;

  void changeContryCode(CountryCode value, {bool refresh = false}) {
    state = value;
    ref
        .read(providerStorage)
        .write(key: Keys.countryCode.name, value: value.code ?? 'CO');
    if (refresh) {
      final _ = ref.refresh(countryCodeFuture);
      final __ = ref.refresh(yunoProvider);
    }
  }
}

extension Converter on Never {
  static CardFlow fromJson(String value) {
    switch (value) {
      case 'oneStep':
        return CardFlow.oneStep;
      case 'multiStep':
        return CardFlow.multiStep;
      default:
        return CardFlow.oneStep;
    }
  }
}
