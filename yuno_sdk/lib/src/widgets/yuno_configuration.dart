import 'package:flutter/material.dart';
import '../internals.dart';

class Yuno extends StatefulWidget {
  const Yuno({
    super.key,
    required this.apiKey,
    required this.sdkType,
    required this.child,
    this.iosConfig,
    this.androidConfig,
  });
  final Widget child;
  final YunoSdkType sdkType;
  final String apiKey;
  final IosConfig? iosConfig;
  final AndroidConfig? androidConfig;

  @override
  State<Yuno> createState() => _YunoState();
}

class _YunoState extends State<Yuno> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await YunoChannels.init(
        apiKey: widget.apiKey,
        iosConfig: widget.iosConfig,
        androidConfig: widget.androidConfig,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
