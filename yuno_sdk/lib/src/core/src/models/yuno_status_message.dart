/// {@template yuno_status_message}
/// Structured detail that accompanies a payment or enrollment [YunoStatus].
///
/// Starting with native Android SDK `2.22.0` and iOS SDK `2.23.0`, every status
/// change may carry a message describing *why* the flow ended in that state. The
/// same five fields are provided by both platforms, so merchants can rely on a
/// single shape regardless of the OS.
///
/// All fields except [source] are optional because the native SDK only
/// populates the ones that are relevant for a given status.
/// {@endtemplate}
class YunoStatusMessage {
  /// {@macro yuno_status_message}
  const YunoStatusMessage({
    this.source = '',
    this.code,
    this.reason,
    this.raw,
    this.context,
  });

  /// Builds a [YunoStatusMessage] from the raw map received over the method
  /// channel. Returns `null` when [map] is `null` so callers can forward the
  /// absence of a message transparently.
  static YunoStatusMessage? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    return YunoStatusMessage(
      source: (map['source'] as String?) ?? '',
      code: map['code'] as String?,
      reason: map['reason'] as String?,
      raw: map['raw'] as String?,
      context: map['context'] as String?,
    );
  }

  /// Where the message originated. Typically `"backend"` or `"sdk"`.
  final String source;

  /// Machine-readable code associated with the status, when available.
  final String? code;

  /// Human-readable explanation of the status.
  final String? reason;

  /// Raw payload provided by the native SDK, when available.
  final String? raw;

  /// Additional context about the status, when available.
  final String? context;

  /// Serializes this message back into a map. Useful for logging and tests.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'source': source,
        'code': code,
        'reason': reason,
        'raw': raw,
        'context': context,
      };

  @override
  String toString() =>
      'YunoStatusMessage(source: $source, code: $code, reason: $reason, '
      'raw: $raw, context: $context)';
}
