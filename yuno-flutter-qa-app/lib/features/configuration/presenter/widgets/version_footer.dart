import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Widget that displays the app version and build number in a footer
///
/// Automatically reads version from pubspec.yaml via package_info_plus
class VersionFooter extends StatelessWidget {
  const VersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              'Version ${packageInfo.version} (Build ${packageInfo.buildNumber})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            'Version ...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}
