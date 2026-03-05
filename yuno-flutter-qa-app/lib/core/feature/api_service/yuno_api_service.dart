import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum YunoEnvironment {
  dev,
  sandbox,
  prod,
  staging;

  String get baseUrl => switch (this) {
        YunoEnvironment.dev => 'https://api-dev.y.uno/v1',
        YunoEnvironment.sandbox => 'https://api-sandbox.y.uno/v1',
        YunoEnvironment.prod => 'https://api.y.uno/v1',
        YunoEnvironment.staging => 'https://api-staging.y.uno/v1',
      };

  static YunoEnvironment fromPublicApiKey(String publicApiKey) {
    final prefix = publicApiKey.split('_').firstOrNull ?? '';
    return switch (prefix) {
      'dev' => YunoEnvironment.dev,
      'sandbox' => YunoEnvironment.sandbox,
      'prod' => YunoEnvironment.prod,
      'staging' => YunoEnvironment.staging,
      _ => YunoEnvironment.staging,
    };
  }
}

class YunoApiService {
  YunoApiService({
    required this.publicApiKey,
    required this.privateSecretKey,
  }) : _environment = YunoEnvironment.fromPublicApiKey(publicApiKey);

  String publicApiKey;
  String privateSecretKey;
  final YunoEnvironment _environment;

  HttpClient _createHttpClient() {
    final client = HttpClient();
    client.findProxy = HttpClient.findProxyFromEnvironment;
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }

  Future<Map<String, dynamic>> _request(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? body,
    Map<String, String> additionalHeaders = const {},
  }) async {
    final uri = Uri.parse('${_environment.baseUrl}$endpoint');
    final client = _createHttpClient();

    try {
      final request = await client.openUrl(method, uri);

      request.headers.set('Content-Type', 'application/json');
      request.headers.set('public-api-key', publicApiKey);
      request.headers.set('private-secret-key', privateSecretKey);
      for (final entry in additionalHeaders.entries) {
        request.headers.set(entry.key, entry.value);
      }

      if (body != null) {
        request.write(jsonEncode(body));
      }

      // Log request
      final requestHeaders = <String, String>{};
      request.headers.forEach((name, values) {
        requestHeaders[name] = values.join(', ');
      });
      // ignore: avoid_print
      print('[YunoApiService] >>> $method $uri');
      // ignore: avoid_print
      print('[YunoApiService] >>> Headers: ${const JsonEncoder.withIndent('  ').convert(requestHeaders)}');
      // ignore: avoid_print
      print('[YunoApiService] >>> Body: ${body != null ? const JsonEncoder.withIndent('  ').convert(body) : 'null'}');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody) as Map<String, dynamic>;

      // Log response
      final responseHeaders = <String, String>{};
      response.headers.forEach((name, values) {
        responseHeaders[name] = values.join(', ');
      });
      // ignore: avoid_print
      print('[YunoApiService] <<< ${response.statusCode} $method $uri');
      // ignore: avoid_print
      print('[YunoApiService] <<< Headers: ${const JsonEncoder.withIndent('  ').convert(responseHeaders)}');
      // ignore: avoid_print
      print('[YunoApiService] <<< Body: ${const JsonEncoder.withIndent('  ').convert(data)}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          message: data['message'] as String? ?? 'API Error: ${response.statusCode}',
          statusCode: response.statusCode,
          data: data,
        );
      }

      return data;
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> createCustomer({
    required String country,
    String? merchantCustomerId,
    String? email,
    String? documentType,
    String? documentNumber,
    String? phoneCountryCode,
    String? phoneNumber,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = <String, dynamic>{
      'merchant_customer_id': merchantCustomerId ?? 'customer_$timestamp',
      'email': email ?? 'test$timestamp@example.com',
      'country': country,
    };

    if (documentType != null && documentNumber != null) {
      payload['document'] = {
        'document_type': documentType,
        'document_number': documentNumber,
      };
    }

    if (phoneCountryCode != null && phoneNumber != null) {
      payload['phone'] = {
        'country_code': phoneCountryCode,
        'number': phoneNumber,
      };
    }

    return _request('/customers', body: payload);
  }

  Future<Map<String, dynamic>> createCheckoutSession({
    required String accountId,
    required String customerId,
    required String country,
    required String currency,
    required num amount,
    String? merchantOrderId,
    String callbackUrl = 'yunoexample://payment',
    String paymentDescription = 'Test payment',
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = {
      'account_id': accountId,
      'country': country,
      'amount': {
        'currency': currency,
        'value': amount,
      },
      'customer_id': customerId,
      'merchant_order_id': merchantOrderId ?? 'order_$timestamp',
      'callback_url': callbackUrl,
      'payment_description': paymentDescription,
    };

    return _request('/checkout/sessions', body: payload);
  }

  Future<Map<String, dynamic>> createCustomerSession({
    required String customerId,
    required String country,
    String callbackUrl = 'yunoexample://enrollment',
  }) async {
    final payload = {
      'country': country,
      'customer_id': customerId,
      'callback_url': callbackUrl,
    };

    return _request('/customers/sessions', body: payload);
  }

  Future<Map<String, dynamic>> createPayment({
    required String accountId,
    required String checkoutSession,
    required String token,
    required String customerId,
    required String merchantOrderId,
    required String country,
    required String currency,
    required num amount,
    bool capture = true,
    String description = 'Test payment',
  }) async {
    final idempotencyKey =
        '${DateTime.now().millisecondsSinceEpoch}_${Random().nextDouble()}';

    final payload = {
      'account_id': accountId,
      'country': country,
      'amount': {
        'currency': currency,
        'value': amount,
      },
      'checkout': {
        'session': checkoutSession,
      },
      'merchant_order_id': merchantOrderId,
      'payment_method': {
        'token': token,
        'detail': {
          'card': {
            'capture': capture,
          },
        },
      },
      'customer_payer': {
        'id': customerId,
      },
      'description': description,
    };

    return _request(
      '/payments',
      body: payload,
      additionalHeaders: {'X-idempotency-key': idempotencyKey},
    );
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    return _request('/payments/$paymentId', method: 'GET');
  }
}

class ApiException implements Exception {
  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

final yunoApiServiceProvider = FutureProvider<YunoApiService?>((ref) async {
  final storage = ref.watch(providerStorage);
  final publicKey = await storage.read(key: Keys.apiKey.name);
  final privateKey = await storage.read(key: Keys.privateSecretKey.name);

  if (publicKey.isEmpty || privateKey.isEmpty) return null;

  return YunoApiService(
    publicApiKey: publicKey,
    privateSecretKey: privateKey,
  );
});

final accountIdProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(providerStorage);
  return await storage.read(key: Keys.accountId.name);
});
