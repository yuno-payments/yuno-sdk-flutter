import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/lib.dart';

void main() {
  group('YunoException', () {
    test('YunoUnexpectedException has correct default values', () {
      final exception = YunoUnexpectedException();
      expect(exception.msg, 'Unexpected Exception');
      expect(exception.preffix, 0);
    });

    test('YunoUnexpectedException allows custom values', () {
      final exception =
          YunoUnexpectedException(msg: 'Custom Message', preffix: 99);
      final exception =
          YunoUnexpectedException(msg: 'Custom Message', preffix: 99);
      expect(exception.msg, 'Custom Message');
      expect(exception.preffix, 99);
    });

    test('YunoMethodNotImplemented has correct default values', () {
      final exception = YunoMethodNotImplemented();
      expect(exception.msg, 'Method not implemented');
      expect(exception.preffix, 1);
    });

    test('YunoMethodNotImplemented allows custom values', () {
      final exception =
          YunoMethodNotImplemented(msg: 'Custom Message', preffix: 99);
      final exception =
          YunoMethodNotImplemented(msg: 'Custom Message', preffix: 99);
      expect(exception.msg, 'Custom Message');
      expect(exception.preffix, 99);
    });

    test('YunoTimeout has correct default values', () {
      final exception = YunoTimeout();
      expect(exception.msg, 'Timeout');
      expect(exception.preffix, 2);
    });

    test('YunoTimeout allows custom values', () {
      final exception = YunoTimeout(msg: 'Custom Message', preffix: 99);
      expect(exception.msg, 'Custom Message');
      expect(exception.preffix, 99);
    });

    test('YunoMissingParam has correct default values', () {
      final exception = YunoMissingParam();
      expect(exception.msg, 'Missing Params');
      expect(exception.preffix, 3);
    });
  });
}
