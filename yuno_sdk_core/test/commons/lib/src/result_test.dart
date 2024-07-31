import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/commons/lib/src/result.dart';


void main() {
  group('Result', () {
    group('Ok', () {
      test('can be created with a value', () {
        final ok = Ok<String, Exception>('Hi');
        expect(ok.value, 'Hi');
      });

      test('toString returns correct value', () {
        final ok = Ok<String, Exception>('Hi');
        expect(ok.toString(), 'Ok(Hi)');
      });

      test('unwrap returns the value', () {
        final ok = Ok<String, Exception>('Hi');
        expect(ok.unwrap(), 'Hi');
      });

      test('unwrapErr throws ResultUnwrapException', () {
        final ok = Ok<String, Exception>('Hi');
        expect(() => ok.unwrapErr(), throwsA(isA<ResultUnwrapException>()));
      });

      test('map transforms the value', () {
        final ok = Ok<String, Exception>('Hi');
        final mapped = ok.map((value) => value.length);
        expect(mapped, isA<Ok<int, Exception>>());
        expect((mapped as Ok).value, 2);
      });

      test('mapErr does not change the value', () {
        final ok = Ok<String, Exception>('Hi');
        final mapped = ok.mapErr((err) => Exception('New Exception'));
        expect(mapped, isA<Ok<String, Exception>>());
        expect((mapped as Ok).value, 'Hi');
      });

      test('unwrapOrNull returns the value', () {
        final ok = Ok<String, Exception>('Hi');
        expect(ok.unwrapOrNull(), 'Hi');
      });
    });

    group('Err', () {
      test('can be created with an exception', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        expect(err.err.toString(), 'Exception: Unexpected');
      });

      test('toString returns correct value', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        expect(err.toString(), 'Err(Exception: Unexpected)');
      });

      test('unwrap throws the exception', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        expect(() => err.unwrap(), throwsA(isA<Exception>()));
      });

      test('unwrapErr returns the exception', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        expect(err.unwrapErr(), isA<Exception>());
      });

      test('map does not change the exception', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        final mapped = err.map((value) => value.length);
        expect(mapped, isA<Err<int, Exception>>());
        expect((mapped as Err).err, isA<Exception>());
      });

      test('mapErr transforms the exception', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        final mapped = err.mapErr((err) => Exception('New Exception'));
        expect(mapped, isA<Err<String, Exception>>());
        expect((mapped as Err).err.toString(), 'Exception: New Exception');
      });

      test('unwrapOrNull returns null', () {
        final err = Err<String, Exception>(Exception('Unexpected'));
        expect(err.unwrapOrNull(), equals(null));
      });
    });
  });
}
