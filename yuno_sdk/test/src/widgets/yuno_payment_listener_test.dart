import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

import '../utils/mock_yuno_platform.dart';

class MockYunoPaymentNotifier extends Mock implements YunoPaymentNotifier {
  final List<VoidCallback> _listeners = [];
  YunoPaymentState _value = const YunoPaymentState(token: '');

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  YunoPaymentState get value => _value;

  void simulateStateChange(YunoPaymentState newState) {
    _value = newState;
    for (final listener in _listeners) {
      listener();
    }
  }
}

void main() {
  late MockYunoPlatform mockPlatform;
  late MockYunoPaymentNotifier mockNotifier;

  setUp(() {
    mockPlatform = MockYunoPlatform();
    mockNotifier = mockPlatform.controller as MockYunoPaymentNotifier;
    YunoPlatform.instance = mockPlatform;
  });

  testWidgets('YunoPaymentListener notifies when payment state changes',
      (WidgetTester tester) async {
    YunoPaymentState? capturedState;
    BuildContext? capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoPaymentListener(
          listener: (context, state) {
            capturedState = state;
            capturedContext = context;
          },
          child: const SizedBox(),
        ),
      ),
    );

    const newState = YunoPaymentState(
      token: 'test-token-123',
      paymentStatus: YunoStatus.succeded,
    );
    mockNotifier.simulateStateChange(newState);
    await tester.pump();

    expect(capturedState, equals(newState));
    expect(capturedContext, isNotNull);
    expect(capturedState?.token, equals('test-token-123'));
    expect(capturedState?.paymentStatus, equals(YunoStatus.succeded));
  });

  testWidgets('YunoPaymentListener renders child correctly',
      (WidgetTester tester) async {
    const key = Key('test-child');
    const child = SizedBox(key: key);

    await tester.pumpWidget(
      MaterialApp(
        home: YunoPaymentListener(
          listener: (_, __) {},
          child: child,
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets(
    'YunoPaymentListener handles multiple payment state changes',
    (WidgetTester tester) async {
      final states = <YunoPaymentState>[];

      await tester.pumpWidget(
        MaterialApp(
          home: YunoPaymentListener(
            listener: (_, state) {
              states.add(state);
            },
            child: const SizedBox(),
          ),
        ),
      );

      const stateChanges = [
        YunoPaymentState(
          token: 'token-1',
          paymentStatus: YunoStatus.processing,
        ),
        YunoPaymentState(
          token: 'token-2',
          paymentStatus: YunoStatus.succeded,
        ),
        YunoPaymentState(
          token: 'token-3',
          paymentStatus: YunoStatus.fail,
        ),
      ];

      for (final state in stateChanges) {
        mockNotifier.simulateStateChange(state);
        await tester.pump();
      }

      expect(states, equals(stateChanges));
      expect(states.map((s) => s.token).toList(),
          equals(['token-1', 'token-2', 'token-3']));
      expect(
        states.map((s) => s.paymentStatus).toList(),
        equals(
          [YunoStatus.processing, YunoStatus.succeded, YunoStatus.fail],
        ),
      );
    },
  );

  testWidgets('YunoPaymentListener handles error states',
      (WidgetTester tester) async {
    YunoPaymentState? capturedState;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoPaymentListener(
          listener: (_, state) {
            capturedState = state;
          },
          child: const SizedBox(),
        ),
      ),
    );

    const errorState = YunoPaymentState(
      token: 'error-token',
      paymentStatus: YunoStatus.internalError,
    );
    mockNotifier.simulateStateChange(errorState);
    await tester.pump();

    expect(capturedState?.paymentStatus, equals(YunoStatus.internalError));
    expect(capturedState?.token, equals('error-token'));
  });

  testWidgets('YunoPaymentListener handles cancel by user',
      (WidgetTester tester) async {
    YunoPaymentState? capturedState;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoPaymentListener(
          listener: (_, state) {
            capturedState = state;
          },
          child: const SizedBox(),
        ),
      ),
    );

    // Simulate cancel by user
    const cancelState = YunoPaymentState(
      token: 'cancel-token',
      paymentStatus: YunoStatus.cancelByUser,
    );
    mockNotifier.simulateStateChange(cancelState);
    await tester.pump();

    expect(capturedState?.paymentStatus, equals(YunoStatus.cancelByUser));
    expect(capturedState?.token, equals('cancel-token'));
  });
}
