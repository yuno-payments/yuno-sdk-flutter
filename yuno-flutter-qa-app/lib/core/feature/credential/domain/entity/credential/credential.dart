class Credential {
  const Credential({
    required this.apiKey,
    required this.countryCode,
    required this.alias,
    this.privateSecretKey = '',
    this.accountId = '',
  });
  final String apiKey;
  final String countryCode;
  final String alias;
  final String privateSecretKey;
  final String accountId;

  @override
  bool operator ==(covariant Credential other) {
    if (identical(this, other)) return true;

    return other.apiKey == apiKey &&
        other.countryCode == countryCode &&
        other.alias == alias &&
        other.privateSecretKey == privateSecretKey &&
        other.accountId == accountId;
  }

  @override
  int get hashCode =>
      apiKey.hashCode ^
      countryCode.hashCode ^
      alias.hashCode ^
      privateSecretKey.hashCode ^
      accountId.hashCode;
}
