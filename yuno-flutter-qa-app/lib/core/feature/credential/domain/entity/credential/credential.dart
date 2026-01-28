class Credential {
  const Credential({
    required this.apiKey,
    required this.countryCode,
    required this.alias,
  });
  final String apiKey;
  final String countryCode;
  final String alias;

  @override
  bool operator ==(covariant Credential other) {
    if (identical(this, other)) return true;

    return other.apiKey == apiKey &&
        other.countryCode == countryCode &&
        other.alias == alias;
  }

  @override
  int get hashCode => apiKey.hashCode ^ countryCode.hashCode ^ alias.hashCode;
}
