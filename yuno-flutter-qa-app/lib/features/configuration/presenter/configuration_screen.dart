import 'package:flutter/material.dart';
import 'package:example/features/configuration/presenter/widgets/card_settings.dart';
import 'package:example/features/configuration/presenter/widgets/general_settings.dart';
import 'package:example/features/configuration/presenter/widgets/ios_appearence.dart';
import 'package:example/features/configuration/presenter/widgets/sdk_settings.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuration',
        ),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: const DefaultConfiguration(),
    );
  }
}

class DefaultConfiguration extends StatelessWidget {
  const DefaultConfiguration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GeneralSettings(),
          SDKSettings(),
          CardSettings(),
          IOSAppearence()
        ],
      ),
    );
  }
}
