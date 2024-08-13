import 'package:flutter/material.dart';
import '../internals.dart';

class YunoProvider extends StatefulWidget {
  const YunoProvider({
    super.key,
    required this.apiKey,
    required this.countryCode,
    required this.sdkType,
    required this.child,
    this.iosConfig,
    this.androidConfig,
  });
  final String apiKey;
  final String countryCode;
  final YunoSdkType sdkType;
  final IosConfig? iosConfig;
  final AndroidConfig? androidConfig;
  final Widget child;

  @override
  State<YunoProvider> createState() => _YunoProviderState();
}

class _YunoProviderState extends State<YunoProvider> {
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Sl.init(sdkType: widget.sdkType);
      await Sl.instance.get<YunoChannels>().configuration(
            apiKey: widget.apiKey,
            countryCode: widget.countryCode,
            iosConfig: widget.iosConfig,
            androidConfig: widget.androidConfig,
          );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    super.dispose();
    Sl.destroy();
  }
}
