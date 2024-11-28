import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

import '../widgets/yuno_enrollment_listener_test.dart';
import '../widgets/yuno_payment_listener_test.dart';

class MockYunoPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements YunoPlatform {
  final MockYunoEnrollmentNotifier _enrollmentController =
      MockYunoEnrollmentNotifier();
  final _controller = MockYunoPaymentNotifier();

  @override
  YunoEnrollmentNotifier get enrollmentController => _enrollmentController;

  @override
  YunoPaymentNotifier get controller => _controller;
}
