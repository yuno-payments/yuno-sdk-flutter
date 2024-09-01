import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuno/yuno.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<Yuno> initYuno() async {
    return await Yuno.init(
      apiKey: '',
      countryCode: '',
      iosConfig: const IosConfig(
        appearance: Appearance(
          buttonBackgrounColor: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Yuno>(
      future: initYuno(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return YunoScope(
            yuno: snapshot.data!,
            child: const _HomeLayout(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class _HomeLayout extends StatefulWidget {
  const _HomeLayout();

  @override
  State<_HomeLayout> createState() => __HomeLayoutState();
}

class __HomeLayoutState extends State<_HomeLayout> {
  String token = '';
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return YunoListener(
      listener: (context, state) {
        setState(() {
          token = state.token;
        });
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.startPaymentLite(
                  arguments: const StartPayment(
                    checkoutSession: '',
                    showPaymentStatus: true,
                    methodSelected: MethodSelected(
                      paymentMethodType: 'CARD',
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
            ),
            TextButton(
              onPressed: () {
                context.continuePayment();
              },
              child: const Center(
                child: Text(
                  'continue payment',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            Row(
              children: [
                Text(token),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: token));
                  },
                  icon: const Center(
                    child: Icon(Icons.copy),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
