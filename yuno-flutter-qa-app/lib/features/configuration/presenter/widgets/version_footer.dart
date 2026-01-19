import 'package:flutter/material.dart';

/// Widget that displays the app version and build number in a footer
/// 
/// Note: Update these constants when updating the version in pubspec.yaml
class VersionFooter extends StatelessWidget {
  const VersionFooter({super.key});

  // Update these values when you update pubspec.yaml version
  static const String version = '1.0.3';
  static const String buildNumber = '2';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      alignment: Alignment.center,
      child: Text(
        'Version $version (Build $buildNumber)',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
