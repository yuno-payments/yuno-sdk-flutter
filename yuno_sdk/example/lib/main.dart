import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

void main() {
  // final injector = Injector();
  // final channels = Result();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: YunoProvider(
        apiKey: '',
        countryCode: '',
        iosConfig: IosConfig(
          cardflow: CARDFLOW.multiStep,
          appearance: Appearance(
            accentColor: Colors.red,
          ),
        ),
        sdkType: YunoSdkType.lite,
        child: Scaffold(
          body: Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
