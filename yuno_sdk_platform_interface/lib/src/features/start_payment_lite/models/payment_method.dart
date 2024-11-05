class MethodSelected {
  const MethodSelected({
    this.vaultedToken,
    required this.paymentMethodType,
  }) : assert(paymentMethodType != "");
  final String? vaultedToken;
  final String paymentMethodType;

  @override
  bool operator ==(covariant MethodSelected other) {
    if (identical(this, other)) return true;

    return other.vaultedToken == vaultedToken &&
        other.paymentMethodType == paymentMethodType;
  }

  @override
  int get hashCode => vaultedToken.hashCode ^ paymentMethodType.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vaultedToken': vaultedToken,
      'paymentMethodType': paymentMethodType,
    };
  }

  @override
  String toString() =>
      'PaymentMethod(vaultedToken: $vaultedToken, paymentMethodType: $paymentMethodType)';
}
