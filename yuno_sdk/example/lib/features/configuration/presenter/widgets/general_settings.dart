import 'package:country_code_picker/country_code_picker.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerNotifier = ref.watch(countryCodeFuture);
    final contryController = ref.watch(contryCodeNotifier.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('General'),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          elevation: 0,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 10,
                  minTileHeight: 10,
                  title: Row(
                    children: [
                      CountryCodePicker(
                        padding: EdgeInsets.zero,
                        initialSelection: controllerNotifier.value ?? "GT",
                        onChanged: (value) =>
                            contryController.changeContryCode(value),
                      ),
                      const Text('Country'),
                    ],
                  ),
                  leading: const Icon(Icons.location_on),
                  onTap: () {},
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
