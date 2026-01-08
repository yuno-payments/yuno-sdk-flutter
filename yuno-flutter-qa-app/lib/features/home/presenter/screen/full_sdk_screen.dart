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

class _SDKLayoutState extends State<_SDKLayout> with SingleTickerProviderStateMixin {
  MethodSelected? methodSelected;

  late final AnimationController _controller;
  late Animation<double> _h;

  double _viewportH = 1.0;
  double _targetH = 1.0;  
  double _maxSeenH = 1.0;  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _h = AlwaysStoppedAnimation(_viewportH);

    _controller.addListener(() {
      setState(() => _viewportH = _h.value);
    });
  }

  void _animateRevealTo(double newH) {
    newH = newH <= 0 ? 1.0 : newH;

    if (newH > _maxSeenH) _maxSeenH = newH;

    _targetH = newH;

    _controller.stop();

    final begin = _viewportH;
    final end = _targetH;

    final delta = (end - begin).abs();
    final ms = (140 + (delta * 0.7)).clamp(180, 520).toInt();
    _controller.duration = Duration(milliseconds: ms);

    _h = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant App'),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 6),
              ClipRect(
                child: SizedBox(
                  height: _viewportH,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minHeight: 0,
                    maxHeight: _maxSeenH, 
                    child: SizedBox(
                      height: _maxSeenH,
                      child: YunoPaymentMethods(
                        config: PaymentMethodConf(checkoutSession: widget.checkoutSession),
                        listener: (context, m, height) {
                          setState(() => methodSelected = m);
                          _animateRevealTo(height);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: methodSelected != null ? () => context.startPayment() : null,
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
    );
  }
}
