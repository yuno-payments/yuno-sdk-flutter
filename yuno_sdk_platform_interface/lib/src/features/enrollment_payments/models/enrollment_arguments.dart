class EnrollmentArguments {
  const EnrollmentArguments({
    required this.customerSession,
    this.showPaymentStatus = true,
    this.countryCode,
  });

  final String? countryCode;
  final String customerSession;
  final bool showPaymentStatus;

  @override
  bool operator ==(covariant EnrollmentArguments other) {
    if (identical(this, other)) return true;

    return other.countryCode == countryCode &&
        other.customerSession == customerSession &&
        other.showPaymentStatus == showPaymentStatus;
  }

  @override
  int get hashCode {
    return countryCode.hashCode ^
        customerSession.hashCode ^
        showPaymentStatus.hashCode;
  }
}
