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
            YunoInput(
              title: 'Coutry code',
              controller: _countryCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contry coude';
                }
                return null;
              },
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

typedef Validator = String? Function(String?)?;

class YunoInput extends StatelessWidget {
  const YunoInput({
    super.key,
    required this.title,
    required this.validator,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;
  final Validator validator;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _controller,
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
          onPressed: () async =>
              await Clipboard.setData(ClipboardData(text: _controller.text)),
          icon: const Icon(
            Icons.copy,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            var cdata = await Clipboard.getData(Clipboard.kTextPlain);
            _controller.text = cdata?.text ?? '';
          },
          icon: const Icon(
            Icons.paste_sharp,
          ),
        ),
      ],
    );
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
