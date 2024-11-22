import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/lib.dart'; // Adjust this import based on your file structure.

void main() {
  group('YunoException Tests', () {
    test('YunoUnexpectedException has correct message and prefix', () {
      final exception = YunoUnexpectedException();
      expect(exception.msg, equals('Unexpected Exception'));
      expect(exception.preffix, equals(0));
    });

    test('YunoMethodNotImplemented has correct message and prefix', () {
      final exception = YunoMethodNotImplemented();
      expect(exception.msg, equals('Method not implemented'));
      expect(exception.preffix, equals(1));
    });

    test('YunoTimeout has correct message and prefix', () {
      final exception = YunoTimeout();
      expect(exception.msg, equals('Timeout'));
      expect(exception.preffix, equals(2));
    });

    test('YunoMissingParam has correct message and prefix', () {
      final exception = YunoMissingParam();
      expect(exception.msg, equals('Missing Params'));
      expect(exception.preffix, equals(3));
    });

    test('YunoInvalidArguments has correct message and prefix', () {
      final exception = YunoInvalidArguments();
      expect(exception.msg, equals('Invalid argument'));
      expect(exception.preffix, equals(4));
    });

    test('YunoNotFoundError has correct message and prefix', () {
      final exception = YunoNotFoundError();
      expect(exception.msg, equals('Not found error'));
      expect(exception.preffix, equals(5));
    });

    test('YunoNotSupport has correct message and prefix', () {
      final exception = YunoNotSupport();
      expect(exception.msg, equals('Method is not avialable for lite version'));
      expect(exception.preffix, equals(6));
    });
  });
}
