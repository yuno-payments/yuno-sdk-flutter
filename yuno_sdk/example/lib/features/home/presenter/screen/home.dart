import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:example/features/configuration/presenter/screen/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const logo = 'https://colombiafintech.co/static/uploads/logo_yuno_morado.png';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBar(
        customHeight: 160,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Consumer(
              builder: (context, ref, child) {
                final controller = ref.watch(credentialNotifier);

                return controller.when(
                  data: (credential) {
                    if (credential.alias.isEmpty ||
                        credential.countryCode.isEmpty ||
                        credential.apiKey.isEmpty) {
                      return const RegisterCard();
                    } else {
                      return Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) async {
                                await ref.read(providerStorage).removeAll();
                                final _ =
                                    ref.refresh(credentialNotifier.future);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConfigurationScreen())),
                            title: Text(
                              credential.alias,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              credential.apiKey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  error: (err, stk) => const RegisterCard(),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class RegisterCard extends StatelessWidget {
  const RegisterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ShowBottomDialog.show(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        color: Colors.white,
        child: const SizedBox(
          height: 50,
          width: 350,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.key),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Add a custom API Key',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Override preferredSize

  CustomNavigationBar({
    super.key,
    this.customHeight = 60.0,
  }) : preferredSize = Size.fromHeight(customHeight);

  final double customHeight;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(customHeight),
      child: Container(
        color: Colors.white,
        height: customHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 110,
                ),
                Row(
                  children: [
                    Image.network(
                      logo,
                      scale: 14,
                      fit: BoxFit.contain,
                    ),
                    const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    const FlutterLogo(
                      size: 35,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowBottomDialog {
  static Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 650,
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    'Add API Key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RegisterForm(),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
