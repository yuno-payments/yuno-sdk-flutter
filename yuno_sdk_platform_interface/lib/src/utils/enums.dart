enum CardFlow {
  oneStep,
  multiStep,
}

extension CardFlowExtension on CardFlow {
  String toJson() {
    return toString().split('.').last;
  }
}
