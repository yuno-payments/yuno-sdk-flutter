import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno_sdk_core/lib.dart';

// Mock class if we had a dependency using YunoStatus
class MockYunoService extends Mock {
  YunoStatus getStatus();
}

void main() {
  group('YunoStatus Enum Tests with mocktail', () {
    late MockYunoService mockYunoService;

    setUp(() {
      // Initialize mock service before each test
      mockYunoService = MockYunoService();
    });

    test('YunoStatus should have all expected values', () {
      expect(YunoStatus.values.length, 6);
      expect(YunoStatus.values, [
        YunoStatus.reject,
        YunoStatus.succeded,
        YunoStatus.fail,
        YunoStatus.processing,
        YunoStatus.internalError,
        YunoStatus.cancelByUser,
      ]);
    });

    test('YunoStatus toString should return correct value', () {
      expect(YunoStatus.reject.toString(), 'YunoStatus.reject');
      expect(YunoStatus.succeded.toString(), 'YunoStatus.succeded');
      expect(YunoStatus.fail.toString(), 'YunoStatus.fail');
      expect(YunoStatus.processing.toString(), 'YunoStatus.processing');
      expect(YunoStatus.internalError.toString(), 'YunoStatus.internalError');
      expect(YunoStatus.cancelByUser.toString(), 'YunoStatus.cancelByUser');
    });

    test('Enum value checks', () {
      expect(YunoStatus.reject.index, 0);
      expect(YunoStatus.succeded.index, 1);
      expect(YunoStatus.fail.index, 2);
      expect(YunoStatus.processing.index, 3);
      expect(YunoStatus.internalError.index, 4);
      expect(YunoStatus.cancelByUser.index, 5);
    });

    test('Mocking a method that returns YunoStatus', () {
      // Set up the mock to return a specific YunoStatus
      when(() => mockYunoService.getStatus()).thenReturn(YunoStatus.succeded);

      // Act
      final status = mockYunoService.getStatus();

      // Assert
      expect(status, YunoStatus.succeded);
      verify(() => mockYunoService.getStatus()).called(1);
    });
  });
}
