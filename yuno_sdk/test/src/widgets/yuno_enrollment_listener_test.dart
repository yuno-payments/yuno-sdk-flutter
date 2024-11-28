import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';
import '../utils/mock_yuno_platform.dart';

class MockYunoEnrollmentNotifier extends Mock
    implements YunoEnrollmentNotifier {
  final List<VoidCallback> _listeners = [];
  YunoEnrollmentState _value = const YunoEnrollmentState();

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  YunoEnrollmentState get value => _value;

  void simulateStateChange(YunoEnrollmentState newState) {
    _value = newState;
    for (final listener in _listeners) {
      listener();
    }
  }
}

void main() {
  late MockYunoPlatform mockPlatform;
  late MockYunoEnrollmentNotifier mockNotifier;

  setUp(() {
    mockPlatform = MockYunoPlatform();
    mockNotifier =
        mockPlatform.enrollmentController as MockYunoEnrollmentNotifier;
    YunoPlatform.instance = mockPlatform;
  });

  testWidgets('YunoEnrollmentListener notifies when state changes',
      (WidgetTester tester) async {
    YunoEnrollmentState? capturedState;
    BuildContext? capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoEnrollmentListener(
          listener: (context, state) {
            capturedState = state;
            capturedContext = context;
          },
          child: const SizedBox(),
        ),
      ),
    );
    const newState = YunoEnrollmentState(
      enrollmentStatus: YunoStatus.succeded,
    );
    mockNotifier.simulateStateChange(newState);
    await tester.pump();
    expect(capturedState, equals(newState));
    expect(capturedContext, isNotNull);
  });

  testWidgets('YunoEnrollmentListener renders child correctly',
      (WidgetTester tester) async {
    const key = Key('test-child');
    const child = SizedBox(key: key);

    await tester.pumpWidget(
      MaterialApp(
        home: YunoEnrollmentListener(
          listener: (_, __) {},
          child: child,
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('YunoEnrollmentListener handles multiple state changes',
      (WidgetTester tester) async {
    final states = <YunoEnrollmentState>[];

    await tester.pumpWidget(
      MaterialApp(
        home: YunoEnrollmentListener(
          listener: (_, state) {
            states.add(state);
          },
          child: const SizedBox(),
        ),
      ),
    );
    const stateChanges = [
      YunoEnrollmentState(enrollmentStatus: YunoStatus.processing),
      YunoEnrollmentState(enrollmentStatus: YunoStatus.succeded),
      YunoEnrollmentState(enrollmentStatus: YunoStatus.fail),
    ];

    for (final state in stateChanges) {
      mockNotifier.simulateStateChange(state);
      await tester.pump();
    }
    expect(states, equals(stateChanges));
  });
}
