import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class HomeViewLite extends StatelessWidget {
  const HomeViewLite({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final either = ref.watch(yunoProvider);

      return switch (either) {
        AsyncError(:final error) => Scaffold(
            body: Text('Error: $error'),
          ),
        AsyncData<Yuno>(:final value) => YunoScope(
            yuno: value,
            child: const _HomeLayout(),
          ),
        _ => const Scaffold(
            body: CircularProgressIndicator(),
          ),
      };
    });
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
                    checkoutSession: 'sdfdsfd',
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
