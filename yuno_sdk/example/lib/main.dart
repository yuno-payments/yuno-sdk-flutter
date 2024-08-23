import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final yuno = await Yuno.init(
    apiKey: '',
    countryCode: '',
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
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text('Hello World!'),
            ),
            TextButton(
              onPressed: () {
                context.startPaymentLite(
                  arguments: const StartPayment(
                    checkoutSession: '',
                    methodSelected: MethodSelected(
                      paymentMethodType: 'sample',
                    ),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  'Pressed',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
