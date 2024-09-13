import 'dart:io';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:example/core/feature/utils/yuno_bottom_sheets.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IOSAppearence extends ConsumerWidget {
  const IOSAppearence({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Platform.isIOS
        ? Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Appearence'),
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
                        title: const Text('Font'),
                        leading: const Icon(Icons.font_download),
                        onTap: () async {
                          await ShowBottomDialog.showFontsList(context);
                          ref.invalidate(appearanceNotifier);
                          final _ = ref.refresh(yunoProvider);
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                        height: 0,
                      ),
                      ListTile(
                        minVerticalPadding: 10,
                        minTileHeight: 10,
                        title: const Text('Select Colors'),
                        leading: const Icon(Icons.color_lens),
                        onTap: () async {
                          await ShowBottomDialog.showAppearence(context);
                          ref.invalidate(appearanceNotifier);
                          final _ = ref.refresh(yunoProvider);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
