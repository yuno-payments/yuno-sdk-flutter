import 'dart:convert';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/feature/credential/domain/entity/credential/credential.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/configuration/presenter/screen/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class AutomationScreen extends ConsumerStatefulWidget {
  const AutomationScreen({super.key});

  @override
  ConsumerState<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends ConsumerState<AutomationScreen> {
  final _jsonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _processJson() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final jsonString = _jsonController.text.trim();
      final Map<String, dynamic> json = jsonDecode(jsonString);

      final storage = ref.read(providerStorage);

      // Extract and save country code
      if (json['country'] != null) {
        await storage.write(
          key: Keys.countryCode.name,
          value: json['country'] as String,
        );
      }

      // Extract and save language
      if (json['language'] != null) {
        final langStr = (json['language'] as String).toLowerCase();
        final lang = YunoLanguage.values.firstWhere(
          (l) => l.rawValue == langStr,
          orElse: () => YunoLanguage.en,
        );
        await storage.write(
          key: Keys.language.name,
          value: lang.rawValue,
        );
      }

      // Extract merchant keys
      if (json['merchantKeys'] != null) {
        final merchantKeys = json['merchantKeys'] as Map<String, dynamic>;
        final publicKey = merchantKeys['publicKey'] as String? ?? '';
        final accountCode = merchantKeys['accountCode'] as String? ?? '';

        // Save as current credential
        await storage.write(key: Keys.apiKey.name, value: publicKey);
        await storage.write(
          key: Keys.alias.name,
          value: accountCode.isNotEmpty
              ? 'Auto-${accountCode.substring(0, accountCode.length > 8 ? 8 : accountCode.length)}'
              : 'Auto-Key',
        );

        // Also save to credentials list
        final existingCredentials = await storage.getCredentials();
        final newCredential = Credential(
          alias: accountCode.isNotEmpty
              ? 'Auto-${accountCode.substring(0, accountCode.length > 8 ? 8 : accountCode.length)}'
              : 'Auto-Key',
          apiKey: publicKey,
          countryCode: json['country'] as String? ?? 'CO',
        );
        final updatedCredentials = [...existingCredentials, newCredential];
        await storage.saveCredentials(updatedCredentials);
      }

      // Extract and save options
      if (json['options'] != null) {
        final options = json['options'] as Map<String, dynamic>;

        // Show payment status
        if (options['showPaymentStatus'] != null) {
          await storage.writeBool(
            key: Keys.showPaymentStatus.name,
            value: options['showPaymentStatus'] as bool,
          );
        }

        // Saved card enable
        if (options['savedCardEnable'] != null) {
          await storage.writeBool(
            key: Keys.saveCardEnable.name,
            value: options['savedCardEnable'] as bool,
          );
        }
      }

      // Invalidate all providers to refresh
      ref.invalidate(credentialNotifier);
      ref.invalidate(credentialsListNotifier);
      ref.invalidate(countryCodeFuture);
      ref.invalidate(langNotifier);
      ref.invalidate(saveCardNotifier);
      ref.invalidate(showPaymentStatusProvider);
      ref.invalidate(yunoProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuration loaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to SetUpScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SetUpScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing JSON: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automation'),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Paste your automation JSON:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jsonController,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: 'Paste JSON here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please paste a JSON';
                  }
                  try {
                    jsonDecode(value.trim());
                    return null;
                  } catch (e) {
                    return 'Invalid JSON format';
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final clipboardData =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData?.text != null) {
                          _jsonController.text = clipboardData!.text!;
                        }
                      },
                      icon: const Icon(Icons.paste),
                      label: const Text('Paste from Clipboard'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _jsonController.clear();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _processJson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Load Configuration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

