import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno_sdk_core/lib.dart';
import '../utils/mock_yuno.dart';

void main() {
  group('YunoScope', () {
    late MockYuno mockYuno;

    setUp(() {
      mockYuno = MockYuno();
    });

    testWidgets('provides Yuno instance to descendants',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        YunoScope(
          yuno: mockYuno,
          child: Builder(
            builder: (BuildContext context) {
              final yuno = YunoScope.of(context);
              expect(yuno, equals(mockYuno));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('throws YunoNotFoundError when not found in context',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            expect(
                () => YunoScope.of(context), throwsA(isA<YunoNotFoundError>()));
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('updateShouldNotify returns true when Yuno instance changes',
        (WidgetTester tester) async {
      final oldYuno = MockYuno();
      final newYuno = MockYuno();

      final oldWidget = YunoScope(yuno: oldYuno, child: const SizedBox());
      final newWidget = YunoScope(yuno: newYuno, child: const SizedBox());

      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    testWidgets(
        'updateShouldNotify returns false when Yuno instance is the same',
        (WidgetTester tester) async {
      final yuno = MockYuno();

      final oldWidget = YunoScope(yuno: yuno, child: const SizedBox());
      final newWidget = YunoScope(yuno: yuno, child: const SizedBox());

      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });

    testWidgets('YunoScope can be nested', (WidgetTester tester) async {
      final outerYuno = MockYuno();
      final innerYuno = MockYuno();

      await tester.pumpWidget(
        YunoScope(
          yuno: outerYuno,
          child: YunoScope(
            yuno: innerYuno,
            child: Builder(
              builder: (BuildContext context) {
                final yuno = YunoScope.of(context);
                expect(yuno, equals(innerYuno));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('YunoScope respects widget tree hierarchy',
        (WidgetTester tester) async {
      final yuno1 = MockYuno();
      final yuno2 = MockYuno();
      late Yuno capturedYuno1;
      late Yuno capturedYuno2;

      await tester.pumpWidget(
        YunoScope(
          yuno: yuno1,
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  capturedYuno1 = YunoScope.of(context);
                  return const SizedBox();
                },
              ),
              YunoScope(
                yuno: yuno2,
                child: Builder(
                  builder: (context) {
                    capturedYuno2 = YunoScope.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      expect(capturedYuno1, equals(yuno1));
      expect(capturedYuno2, equals(yuno2));
    });
  });

  group('YunoReader', () {
    testWidgets('extension method returns Yuno instance',
        (WidgetTester tester) async {
      late Yuno capturedYuno;
      final mockYuno = MockYuno();

      await tester.pumpWidget(
        YunoScope(
          yuno: mockYuno,
          child: Builder(
            builder: (BuildContext context) {
              capturedYuno = context.yuno();
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedYuno, equals(mockYuno));
    });

    testWidgets(
        'extension method throws YunoNotFoundError when YunoScope is not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            expect(() => context.yuno(), throwsA(isA<YunoNotFoundError>()));
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('extension method works with multiple YunoScopes',
        (WidgetTester tester) async {
      final outerYuno = MockYuno();
      final innerYuno = MockYuno();
      late Yuno capturedOuterYuno;
      late Yuno capturedInnerYuno;

      await tester.pumpWidget(
        YunoScope(
          yuno: outerYuno,
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  capturedOuterYuno = context.yuno();
                  return const SizedBox();
                },
              ),
              YunoScope(
                yuno: innerYuno,
                child: Builder(
                  builder: (context) {
                    capturedInnerYuno = context.yuno();
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      expect(capturedOuterYuno, equals(outerYuno));
      expect(capturedInnerYuno, equals(innerYuno));
    });
  });
}
