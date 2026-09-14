import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno/src/platform_interface/src.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('YunoStatusMessage.fromMap', () {
    test('returns null when the map is null', () {
      expect(YunoStatusMessage.fromMap(null), isNull);
    });

    test('parses all fields from the native map', () {
      final message = YunoStatusMessage.fromMap(const {
        'source': 'backend',
        'code': 'DECLINED',
        'reason': 'Insufficient funds',
        'raw': '{"error":"insufficient_funds"}',
        'context': 'authorization',
      });

      expect(message, isNotNull);
      expect(message!.source, 'backend');
      expect(message.code, 'DECLINED');
      expect(message.reason, 'Insufficient funds');
      expect(message.raw, '{"error":"insufficient_funds"}');
      expect(message.context, 'authorization');
    });

    test('defaults source to empty and keeps missing fields null', () {
      final message = YunoStatusMessage.fromMap(const {'code': 'X'});

      expect(message!.source, '');
      expect(message.code, 'X');
      expect(message.reason, isNull);
      expect(message.raw, isNull);
      expect(message.context, isNull);
    });
  });

  group('YunoMethodChannel status handler', () {
    const channelName = 'yuno/payments';
    late YunoPaymentNotifier paymentNotifier;
    late YunoEnrollmentNotifier enrollmentNotifier;

    Future<void> sendCall(String method, Object? arguments) {
      return TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .handlePlatformMessage(
        channelName,
        const StandardMethodCodec()
            .encodeMethodCall(MethodCall(method, arguments)),
        (_) {},
      );
    }

    setUp(() async {
      paymentNotifier = YunoPaymentNotifier();
      enrollmentNotifier = YunoEnrollmentNotifier();
      final channel = YunoMethodChannel(
        methodChannel: const MethodChannel(channelName),
        platformIsIos: false,
        platformIsAndroid: true,
        yunoNotifier: paymentNotifier,
        yunoEnrollmentNotifier: enrollmentNotifier,
      );
      await channel.setup();
    });

    test('maps a { status, message } payload to state + message', () async {
      await sendCall('status', const {
        'status': 1,
        'message': {
          'source': 'backend',
          'code': 'OK',
          'reason': 'Approved',
        },
      });

      expect(paymentNotifier.value.paymentStatus, YunoStatus.succeeded);
      expect(paymentNotifier.value.message?.source, 'backend');
      expect(paymentNotifier.value.message?.code, 'OK');
      expect(paymentNotifier.value.message?.reason, 'Approved');
    });

    test('keeps message null when the payload omits it', () async {
      await sendCall('status', const {'status': 0});

      expect(paymentNotifier.value.paymentStatus, YunoStatus.reject);
      expect(paymentNotifier.value.message, isNull);
    });

    test('still supports a bare int status for backward compatibility',
        () async {
      await sendCall('status', 2);

      expect(paymentNotifier.value.paymentStatus, YunoStatus.fail);
      expect(paymentNotifier.value.message, isNull);
    });

    test('ignores an out-of-range status index', () async {
      await sendCall('status', const {'status': 99});

      expect(paymentNotifier.value.paymentStatus, isNull);
    });

    test('maps the enrollment payload to state + message', () async {
      await sendCall('enrollmentStatus', const {
        'status': 1,
        'message': {'source': 'sdk', 'reason': 'Enrolled'},
      });

      expect(enrollmentNotifier.value.enrollmentStatus, YunoStatus.succeeded);
      expect(enrollmentNotifier.value.message?.source, 'sdk');
      expect(enrollmentNotifier.value.message?.reason, 'Enrolled');
    });
  });
}
