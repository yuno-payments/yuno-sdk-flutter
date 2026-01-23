import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/core/feature/utils/ott_modal.dart';
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

class _SDKLayout extends ConsumerStatefulWidget {
  const _SDKLayout({required this.checkoutSession});
  final String checkoutSession;
  
  @override
  ConsumerState<_SDKLayout> createState() => _SDKLayoutState();
}

class _SDKLayoutState extends ConsumerState<_SDKLayout> {
  MethodSelected? methodSelected;
  String? _lastProcessedToken;
  late final String _uniqueKey;

  @override
  void initState() {
    super.initState();
    // Reset state when widget is initialized
    methodSelected = null;
    _lastProcessedToken = null;
    // Generate unique key for YunoPaymentMethods to force recreation
    _uniqueKey = '${widget.checkoutSession}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant App'),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: YunoMultiListener(
        enrollmentListener: (context, state) {
          // Handle enrollment if needed
        },
        paymentListener: (context, state) {
          // Show OTT modal when received
          // Only show if token is not empty and token is different from last processed
          if (state.token.isNotEmpty && state.token != _lastProcessedToken) {
            _lastProcessedToken = state.token;
            OttModal.show(
              context: context,
              ott: state.token,
              onContinue: () async {
                final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                await context.continuePayment(showPaymentStatus: showPaymentStatus);
              },
              onDismissed: () {
                // Reset token to allow showing new OTT
                if (mounted) {
                  setState(() {
                    _lastProcessedToken = null;
                  });
                }
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 6),
                // TODO: Temporal - Reemplazar YunoPaymentMethods con cuadro amarillo
                YunoPaymentMethods(
                  key: ValueKey(_uniqueKey),
                  config: PaymentMethodConf(checkoutSession: widget.checkoutSession),
                  listener: (context, m, height) {
                    setState(() {
                      methodSelected = m;
                    });
                  },
                ),
                // Container(
                //   height: 300,
                //   width: double.infinity,
                //   color: Colors.yellow,
                // ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: methodSelected != null 
                      ? () async {
                          final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                          await context.startPayment(showPaymentStatus: showPaymentStatus);
                        }
                      : null,
                  child: Text(
                    methodSelected != null
                        ? 'Pay with ${methodSelected!.paymentMethodType}'
                        : 'Pay',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
