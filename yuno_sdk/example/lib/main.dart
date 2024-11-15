import 'package:example/environments.dart';
import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Yuno.init(
      apiKey: Environments.apiKey, countryCode: 'YOUR_COUNTRY_CODE');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startPaymentLite() {
    Yuno.startPaymentLite(
      arguments: const StartPayment(
        checkoutSession: 'CHECKOUT_SESSION_ID',
        methodSelected:
            MethodSelected(paymentMethodType: 'PAYMENT_METHOD_TYPE'),
      ),
    );
  }

  void _startPayment() {
    Yuno.startPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // FOR FULL SDK VERSION
            YunoPaymentMethods(
              config: const PaymentMethodConf(
                  checkoutSession: 'YOUR_CHECKOUT_SESSION_ID'),
              listener: (context, isSelected) {},
            ),
            TextButton(
              onPressed: _startPaymentLite,
              child: const Text('Start Payment Lite'),
            ),
            TextButton(
              onPressed: _startPayment,
              child: const Text('Start Payment'),
            )
          ],
        ),
      ),
    );
  }
}
