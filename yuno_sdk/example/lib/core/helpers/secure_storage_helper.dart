import 'package:example/core/feature/credential/domain/entity/credential/credential.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage({
    required this.storage,
  });
  final FlutterSecureStorage storage;

  Future<void> write({
    required String key,
    required String value,
  }) async {
    await storage.write(
      key: key,
      value: value,
    );
  }

  Future<String> read({
    required String key,
  }) async {
    return await storage.read(key: key) ?? '';
  }

  Future<void> removeAll() async {
    await storage.deleteAll();
  }
}

final credentialNotifier = FutureProvider<Credential>(
  (ref) async {
    final apiKey = await ref.watch(providerStorage).read(
          key: Keys.apiKey.name,
        );
    final countryCode =
        await ref.watch(providerStorage).read(key: Keys.countryCode.name);
    final alias = await ref.watch(providerStorage).read(
          key: Keys.alias.name,
        );

    return Credential(
      apiKey: apiKey,
      countryCode: countryCode,
      alias: alias,
    );
  },
);

final providerStorage = Provider<SecureStorage>(
  (ref) => SecureStorage(
    storage: ref.read(_secureStorageProvider),
  ),
);

final _secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);
