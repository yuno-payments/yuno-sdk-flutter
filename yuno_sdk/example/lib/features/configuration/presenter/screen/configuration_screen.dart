import 'package:example/core/feature/utils/yuno_assets.dart';
import 'package:example/features/configuration/presenter/ios_configuration_screen.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:example/core/feature/utils/yuno_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'General Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Text('IOS Configuration '),
                  Image.asset(
                    YunoAssets.appleIC,
                    height: 20,
                    width: 20,
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const IOSConfigurationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Text('Android Configuration '),
                  Image.asset(
                    YunoAssets.androidIC,
                    height: 20,
                    width: 20,
                  )
                ],
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return YunoListener(
            listener: (context, state) {
              ref
                  .read(checkoutSessionNotifier.notifier)
                  .recoverySession(state.token);
              YunoSnackBar.showSnackBar(
                context,
                state.status,
                () {
                  ref.read(checkoutSessionNotifier.notifier).resetSession();
                },
              );
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'PAYMENT',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExecutePayments()
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExecutePayments extends StatefulWidget {
  const ExecutePayments({
    super.key,
  });

  @override
  State<ExecutePayments> createState() => _ExecutePaymentsState();
}

class _ExecutePaymentsState extends State<ExecutePayments> {
  final _checkoutSession = TextEditingController();
  final _paymentType = TextEditingController(text: 'CARD');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                YunoInput(
                  title: 'Checkout session',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a checkout session';
                    }
                    return null;
                  },
                  controller: _checkoutSession,
                ),
                const SizedBox(
                  height: 10,
                ),
                YunoInput(
                  title: 'Payment type',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an payment type';
                    }
                    return null;
                  },
                  controller: _paymentType,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListTile(
                  minVerticalPadding: 3,
                  minTileHeight: 2,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.startPaymentLite(
                        arguments: StartPayment(
                          showPaymentStatus: true,
                          checkoutSession: _checkoutSession.text,
                          methodSelected: MethodSelected(
                            paymentMethodType: _paymentType.text,
                          ),
                        ),
                      );
                    }
                  },
                  title: const Text('Execute payment LITE'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
                const Divider(),
                Consumer(
                  builder: (context, ref, child) {
                    final controller = ref.watch(checkoutSessionNotifier);

                    return controller.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'OTT:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      controller,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async =>
                                          await Clipboard.setData(
                                              ClipboardData(text: controller)),
                                      icon: const Icon(
                                        Icons.copy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async =>
                                    context.continuePayment(),
                                style: ButtonStyle(
                                  elevation: const WidgetStatePropertyAll(0),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  backgroundColor: const WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                ),
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      'Continue Payment',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final checkoutSessionNotifier =
    NotifierProvider.autoDispose<CheckoutSessionNotifier, String>(
        CheckoutSessionNotifier.new);

class CheckoutSessionNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() => '';

  void recoverySession(String value) => state = value;

  void resetSession() => state = '';
}
