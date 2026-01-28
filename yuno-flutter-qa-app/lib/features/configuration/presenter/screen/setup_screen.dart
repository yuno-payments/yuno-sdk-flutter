import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/configuration/presenter/widgets/execute_payment_cards.dart';
import 'package:flutter/material.dart';
import 'package:example/features/configuration/presenter/configuration_screen.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:example/core/feature/utils/yuno_snackbar.dart';
import 'package:example/core/feature/utils/ott_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuno/yuno.dart';

class SetUpScreen extends StatelessWidget {
  const SetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final either = ref.watch(yunoProvider);

      return switch (either) {
        AsyncError(:final error) => Scaffold(
            body: Text('Error: $error'),
          ),
        AsyncData<void>() => const _HomeLayout(),
        _ => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
  String? _lastProcessedToken;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        title: const Text('Payment Setup'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfigurationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return YunoMultiListener(
            enrollmentListener: (context, state) {
              YunoSnackBar.showSnackBar(
                context,
                YunoSnackbarOptions.enrollment,
                state.enrollmentStatus,
                () {
                  ref.read(checkoutSessionNotifier.notifier).resetSession();
                },
              );
            },
            paymentListener: (context, state) {
              ref
                  .read(checkoutSessionNotifier.notifier)
                  .recoverySession(state.token);
              
              // Show OTT modal instead of displaying it in the screen
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
              
              YunoSnackBar.showSnackBar(
                context,
                YunoSnackbarOptions.payment,
                state.paymentStatus,
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
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExecuteEnrollments(),
                        SizedBox(
                          height: 10,
                        ),
                        ExecutePayments(),
                      ],
                    ),
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

class ExecuteEnrollments extends ConsumerStatefulWidget {
  const ExecuteEnrollments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExecuteEnrollmentsState();
}

class _ExecuteEnrollmentsState extends ConsumerState<ExecuteEnrollments> {
  final _enrollmentPayment = TextEditingController();
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
                'Enrollment',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 126, 126),
                  fontSize: 15,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: !ref.watch(customerFormNotifier) ? 0 : 1,
              duration: Durations.short3,
              child: ActionChip(
                label: const Text('Clean'),
                onPressed: () {
                  ref.read(customerSessionNotifier.notifier).resetSession();
                  ref
                      .read(customerFormNotifier.notifier)
                      .changeValue(value: false);
                  _enrollmentPayment.clear();
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
                      title: 'Customer Session',
                      controller: _enrollmentPayment,
                      onPaste: () => ref
                          .read(customerFormNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
                      onChange: (p0) => ref
                          .read(customerFormNotifier.notifier)
                          .changeValue(
                              value:
                                  _formKey.currentState?.validate() ?? false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a customer session';
                        }
                        return null;
                      },
                    ),
                    const Divider(),
                    ListTile(
                      minVerticalPadding: 3,
                      minTileHeight: 2,
                      title: const Text('Execute payment Enrollment'),
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          ref.invalidate(yunoProvider);
                          // Wait for SDK reinitialization to complete before starting enrollment
                          await ref.read(yunoProvider.future);
                          final showPaymentStatus = await ref.read(showPaymentStatusProvider.future);
                          await context.enrollmentPayment(
                            arguments: EnrollmentArguments(
                              customerSession: _enrollmentPayment.text,
                              showPaymentStatus: showPaymentStatus,
                            ),
                          );
                        }
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
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

final customerSessionNotifier =
    NotifierProvider.autoDispose<CustomerSessionNotifier, String>(
        CustomerSessionNotifier.new);

final customerFormNotifier =
    NotifierProvider.autoDispose<CustomerFormNotifier, bool>(
        CustomerFormNotifier.new);

class CustomerSessionNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() => '';

  void recoverySession(String value) => state = value;

  void resetSession() => state = '';
}

class CustomerFormNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false;

  void changeValue({required bool value}) => state = value;
}
