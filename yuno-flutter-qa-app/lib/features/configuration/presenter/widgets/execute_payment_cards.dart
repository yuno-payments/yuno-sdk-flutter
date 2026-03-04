import 'package:example/core/feature/api_service/yuno_api_service.dart';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/core/feature/utils/ott_modal.dart';
import 'package:example/features/home/presenter/screen/full_sdk_screen.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/material.dart';
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
  String? _lastProcessedToken;
  String? _customerId;
  bool _isGenerating = false;
  bool _isModalOpen = false;

  Future<void> _generateCheckoutSession(WidgetRef ref) async {
    setState(() => _isGenerating = true);
    try {
      final apiService = await ref.read(yunoApiServiceProvider.future);
      final accountId = await ref.read(accountIdProvider.future);
      final countryCode = await ref.read(countryCodeFuture.future);
      final amount = await ref.read(paymentAmountProvider.future);
      final currency = await ref.read(paymentCurrencyProvider.future);

      if (apiService == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Missing private key. Configure it in credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (accountId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Missing account code. Configure it in credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final country = countryCode.isEmpty ? 'CO' : countryCode;

      final customer = await apiService.createCustomer(country: country);
      final customerId = customer['id'] as String;
      _customerId = customerId;

      final session = await apiService.createCheckoutSession(
        accountId: accountId,
        customerId: customerId,
        country: country,
        amount: amount,
        currency: currency,
      );
      final checkoutSession = session['checkout_session'] as String;

      if (mounted) {
        _checkoutSession.text = checkoutSession;
        ref.read(formNotifier.notifier).changeValue(
            value: _formKey.currentState?.validate() ?? false);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showPaymentMethodsModal(BuildContext context, String checkoutSession) {
    _isModalOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useRootNavigator: false,
      builder: (context) => _PaymentMethodsModal(
        key: ValueKey('payment_modal_${DateTime.now().millisecondsSinceEpoch}'),
        checkoutSession: checkoutSession,
        customerId: _customerId,
        onPayment: () async {
          final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
          await context.startPayment(showPaymentStatus: showPaymentStatus);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    ).then((_) {
      _isModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return YunoMultiListener(
      enrollmentListener: (context, state) {
        // Handle enrollment if needed
      },
      paymentListener: (context, state) async {
        if (_isModalOpen) return;
        if (state.token.isNotEmpty && state.token != _lastProcessedToken) {
          _lastProcessedToken = state.token;
          final isAutomaticPayment = await ref.read(automaticPaymentProvider.future);

          if (isAutomaticPayment) {
            // Automatic payment: create payment via API if possible, then continue
            try {
              if (_customerId != null) {
                final apiService = await ref.read(yunoApiServiceProvider.future);
                final accountId = await ref.read(accountIdProvider.future);
                final countryCode = await ref.read(countryCodeFuture.future);
                final country = countryCode.isEmpty ? 'CO' : countryCode;
                final amount = await ref.read(paymentAmountProvider.future);
                final currency = await ref.read(paymentCurrencyProvider.future);

                if (apiService != null) {
                  await apiService.createPayment(
                    accountId: accountId,
                    checkoutSession: _checkoutSession.text,
                    token: state.token,
                    customerId: _customerId!,
                    merchantOrderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
                    country: country,
                    amount: amount,
                    currency: currency,
                  );
                }
              }
              final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
              if (context.mounted) {
                await context.continuePayment(showPaymentStatus: showPaymentStatus);
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Auto payment error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
                _lastProcessedToken = null;
              }
            }
          } else {
            // Manual flow: show OTT modal
            OttModal.show(
              context: context,
              ott: state.token,
              onContinue: () async {
                final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                await context.continuePayment(showPaymentStatus: showPaymentStatus);
              },
              onDismissed: () {
                if (mounted) {
                  setState(() {
                    _lastProcessedToken = null;
                  });
                }
              },
            );
          }
        }
      },
      child: Column(
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
                  _paymentType.clear();
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
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isGenerating
                            ? null
                            : () => _generateCheckoutSession(ref),
                        child: _isGenerating
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Generate'),
                      ),
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
                      controller: _paymentType,
                      validator: (value) => null,
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
                          // Wait for SDK reinitialization to complete before starting payment
                          await ref.read(yunoProvider.future);
                          final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                          await context.startPaymentLite(
                            arguments: StartPayment(
                              showPaymentStatus: showPaymentStatus,
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
                        if (_formKey.currentState?.validate() ?? false) {
                          ref.invalidate(yunoProvider);
                          // Wait for SDK reinitialization to complete before showing modal
                          await ref.read(yunoProvider.future);
                          _showPaymentMethodsModal(context, _checkoutSession.text);
                        }
                      },
                      title: const Text('Execute payment FULL'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class _PaymentMethodsModal extends ConsumerStatefulWidget {
  const _PaymentMethodsModal({
    super.key,
    required this.checkoutSession,
    required this.onPayment,
    this.customerId,
  });

  final String checkoutSession;
  final VoidCallback onPayment;
  final String? customerId;

  @override
  ConsumerState<_PaymentMethodsModal> createState() => _PaymentMethodsModalState();
}

class _PaymentMethodsModalState extends ConsumerState<_PaymentMethodsModal> {
  MethodSelected? methodSelected;
  late final String _uniqueKey;
  String? _lastProcessedToken;
  double _paymentMethodsHeight = 100.0; // Initial small height for Android

  @override
  void initState() {
    super.initState();
    // Reset all state to ensure clean initialization
    methodSelected = null;
    _lastProcessedToken = null;
    _paymentMethodsHeight = 100.0; // Reset to initial height
    _uniqueKey = '${widget.checkoutSession}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return YunoMultiListener(
      enrollmentListener: (context, state) {
        // Handle enrollment if needed
      },
      paymentListener: (context, state) async {
        if (state.token.isNotEmpty && state.token != _lastProcessedToken) {
          _lastProcessedToken = state.token;
          final isAutomaticPayment = await ref.read(automaticPaymentProvider.future);

          if (isAutomaticPayment) {
            try {
              if (widget.customerId != null) {
                final apiService = await ref.read(yunoApiServiceProvider.future);
                final accountId = await ref.read(accountIdProvider.future);
                final countryCode = await ref.read(countryCodeFuture.future);
                final country = countryCode.isEmpty ? 'CO' : countryCode;
                final amount = await ref.read(paymentAmountProvider.future);
                final currency = await ref.read(paymentCurrencyProvider.future);

                if (apiService != null) {
                  await apiService.createPayment(
                    accountId: accountId,
                    checkoutSession: widget.checkoutSession,
                    token: state.token,
                    customerId: widget.customerId!,
                    merchantOrderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
                    country: country,
                    amount: amount,
                    currency: currency,
                  );
                }
              }
              final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
              if (context.mounted) {
                await context.continuePayment(showPaymentStatus: showPaymentStatus);
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Auto payment error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
                setState(() {
                  _lastProcessedToken = null;
                });
              }
            }
          } else {
            OttModal.show(
              context: context,
              ott: state.token,
              onContinue: () async {
                final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                await context.continuePayment(showPaymentStatus: showPaymentStatus);
              },
              onDismissed: () {
                if (mounted) {
                  setState(() {
                    _lastProcessedToken = null;
                  });
                }
              },
            );
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Payment methods widget - wrapped to handle initial sizing on Android
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _paymentMethodsHeight,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: YunoPaymentMethods(
                          key: ValueKey(_uniqueKey),
                          config: PaymentMethodConf(
                            checkoutSession: widget.checkoutSession,
                          ),
                          listener: (context, m, height) {
                            if (mounted) {
                              setState(() {
                                methodSelected = m;
                                // Update height when widget reports its real height
                                // Only update if height is reasonable (not the initial 2000.0)
                                // And only if height is >= 100 to maintain minimum modal size
                                if (height >= 100 && height < 2000) {
                                  final maxHeight = MediaQuery.of(context).size.height * 0.5;
                                  _paymentMethodsHeight = height > maxHeight ? maxHeight : height;
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Pay button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: methodSelected != null ? widget.onPayment : null,
                  child: Text(
                    methodSelected != null
                        ? 'Pay with ${methodSelected!.paymentMethodType}'
                        : 'Select a payment method',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Close button
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Ensure modal is completely dismissed
                    Navigator.of(context, rootNavigator: false).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset all state when modal is disposed to ensure clean state for next opening
    // This is especially important for iOS real devices where views can persist
    methodSelected = null;
    _lastProcessedToken = null;
    _paymentMethodsHeight = 100.0;
    super.dispose();
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
