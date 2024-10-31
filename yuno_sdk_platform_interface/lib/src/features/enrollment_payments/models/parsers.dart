import 'enrollment_arguments.dart';

extension EnrollmentArgumentsParser on EnrollmentArguments {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countryCode': countryCode,
      'customerSession': customerSession,
      'showPaymentStatus': showPaymentStatus,
    };
  }
}
