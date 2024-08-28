import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/material.dart';
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
  final _countryCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              controller: _aliasController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an alias';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Alias',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _countryCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contry coude';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Coutry code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _apiController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your api key';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Public Api Key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
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
    if (_formKey.currentState!.validate()) {
      await storage.write(key: Keys.alias.name, value: _aliasController.text);
      await storage.write(key: Keys.apiKey.name, value: _apiController.text);
      await storage.write(
          key: Keys.countryCode.name, value: _countryCodeController.text);
      final _ = ref.refresh(credentialNotifier.future);
      _formKey.currentState!.reset();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}

final yunoProvider = FutureProvider<Yuno>((ref) async {
  final apiKey = await ref.watch(providerStorage).read(key: Keys.apiKey.name);
  final countryCode =
      await ref.watch(providerStorage).read(key: Keys.countryCode.name);
  return await Yuno.init(
    apiKey: apiKey,
    countryCode: countryCode,
    iosConfig: const IosConfig(
      keepLoader: true,
      appearance: Appearance(
        buttonBackgrounColor: Colors.red,
      ),
    ),
  );
});
