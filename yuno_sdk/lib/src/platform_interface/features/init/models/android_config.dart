import 'ios_config.dart';

class AndroidConfig {
  const AndroidConfig({
    this.appearance,
  });

  final Appearance? appearance;

  @override
  bool operator ==(covariant AndroidConfig other) {
    if (identical(this, other)) return true;
    return other.appearance == appearance;
  }

  @override
  int get hashCode => appearance.hashCode;
}
