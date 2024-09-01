class AndroidConfig {
  const AndroidConfig({
    this.cardFormDeployed = false,
  });

  final bool cardFormDeployed;

  @override
  bool operator ==(covariant AndroidConfig other) {
    if (identical(this, other)) return true;

    return other.cardFormDeployed == cardFormDeployed;
  }

  @override
  int get hashCode {
    return cardFormDeployed.hashCode;
  }
}
