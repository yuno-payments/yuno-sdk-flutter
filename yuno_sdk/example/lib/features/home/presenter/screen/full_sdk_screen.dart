import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class FullSdkScreen extends StatelessWidget {
  const FullSdkScreen({
    super.key,
    required this.checkoutSession,
  });
  final String checkoutSession;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final either = ref.watch(yunoProvider);

      return switch (either) {
        AsyncError(:final error) => Scaffold(
            body: Text('Error: $error'),
          ),
        AsyncData<void>() => _SDKLayout(
            checkoutSession: checkoutSession,
          ),
        _ => const Scaffold(
            body: CircularProgressIndicator(),
          ),
      };
    });
  }
}

class _SDKLayout extends StatefulWidget {
  const _SDKLayout({required this.checkoutSession});
  final String checkoutSession;
  @override
  State<_SDKLayout> createState() => _SDKLayoutState();
}

class _SDKLayoutState extends State<_SDKLayout> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant App'),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Column(
              children: [
                YunoPaymentMethods(
                  config: PaymentMethodConf(
                    checkoutSession: widget.checkoutSession,
                  ),
                  listener: (context, isSelected) {
                    setState(() {
                      this.isSelected = isSelected;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isSelected
                      ? () async {
                          if (isSelected) {
                            context.startPayment();
                          }
                        }
                      : null,
                  child: const Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
