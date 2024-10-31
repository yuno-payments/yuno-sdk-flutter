import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/features/home/presenter/screen/full_sdk_screen.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class ExecutePayments extends ConsumerStatefulWidget {
  const ExecutePayments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExecutePaymentsState();
}

class _ExecutePaymentsState extends ConsumerState<ExecutePayments> {
  final _checkoutSession = TextEditingController();
  final _vaultedToken = TextEditingController();
  final _paymentType = TextEditingController(text: 'CARD');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'PAYMENT',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 126, 126),
                  fontSize: 12,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: !ref.watch(formNotifier) ? 0 : 1,
              duration: Durations.short3,
              child: ActionChip(
                label: const Text('Clean'),
                onPressed: () {
                  ref.read(checkoutSessionNotifier.notifier).resetSession();
                  ref.read(formNotifier.notifier).changeValue(value: false);
                  _checkoutSession.clear();
                  _vaultedToken.clear();
                },
              ),
            ),
          ],
        ),
        Card(
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
                      onPaste: () => ref
                          .read(formNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
                      controller: _checkoutSession,
                      onChange: (p0) => ref
                          .read(formNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a checkout session';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    YunoInput(
                      title: 'Payment type',
                      onPaste: () => ref
                          .read(formNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
                      onChange: (p0) => ref
                          .read(formNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
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
                    YunoInput(
                      title: 'Vaulted token',
                      onPaste: () {},
                      controller: _vaultedToken,
                      onChange: (p0) {},
                      validator: (p0) => null,
                    ),
                    const Divider(),
                    ListTile(
                      minVerticalPadding: 3,
                      minTileHeight: 2,
                      title: const Text('Execute payment LITE'),
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          ref.invalidate(yunoProvider);
                          await context.startPaymentLite(
                            arguments: StartPayment(
                              showPaymentStatus: true,
                              checkoutSession: _checkoutSession.text,
                              methodSelected: MethodSelected(
                                vaultedToken: _vaultedToken.text.isEmpty
                                    ? null
                                    : _vaultedToken.text,
                                paymentMethodType: _paymentType.text,
                              ),
                            ),
                          );
                        }
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      minVerticalPadding: 3,
                      minTileHeight: 2,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullSdkScreen(
                                checkoutSession: _checkoutSession.text,
                              ),
                            ),
                          );
                        }
                      },
                      title: const Text('Execute payment FULL'),
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
                                                  ClipboardData(
                                                      text: controller)),
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
                                      elevation:
                                          const WidgetStatePropertyAll(0),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
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
        ),
      ],
    );
  }
}

final checkoutSessionNotifier =
    NotifierProvider.autoDispose<CheckoutSessionNotifier, String>(
        CheckoutSessionNotifier.new);

final formNotifier = NotifierProvider.autoDispose<FormValidatorNotifier, bool>(
    FormValidatorNotifier.new);

class CheckoutSessionNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() => '';

  void recoverySession(String value) => state = value;

  void resetSession() => state = '';
}

class FormValidatorNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false;

  void changeValue({required bool value}) => state = value;
}
