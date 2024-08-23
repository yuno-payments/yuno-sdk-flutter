import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final yuno = await Yuno.init(
    apiKey: '',
    sdkType: YunoSdkType.full,
  );

  runApp(
    YunoScope(
      yuno: yuno,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.yuno();
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
