enum CARDFLOW {
  oneStep,
  multiStep,
}

extension CardFlowExtension on CARDFLOW {
  String toJson() {
    return toString().split('.').last;
  }
}
