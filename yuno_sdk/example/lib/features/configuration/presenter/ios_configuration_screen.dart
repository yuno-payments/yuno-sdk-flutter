import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IOSConfigurationScreen extends ConsumerWidget {
  const IOSConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuration',
        ),
        backgroundColor: const Color(0xFFF2F2F7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
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
                      title: const Text('Language'),
                      leading: const Icon(Icons.language),
                      onTap: () {},
                    ),
                    const Divider(
                      thickness: 0.5,
                      height: 0,
                    ),
                    ListTile(
                      minVerticalPadding: 10,
                      minTileHeight: 10,
                      title: const Text('Country'),
                      leading: const Icon(Icons.location_on),
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
