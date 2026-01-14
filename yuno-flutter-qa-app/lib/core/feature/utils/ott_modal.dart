import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuno/yuno.dart';

/// Shows a modal dialog displaying the OTT (One-Time Token) with action buttons.
///
/// This modal provides three actions:
/// - Copy: Copies the OTT to clipboard
/// - Continue: Continues the payment flow
/// - Close: Closes the modal
///
/// Parameters:
/// - [context]: The build context for showing the dialog
/// - [ott]: The One-Time Token to display
/// - [onContinue]: Optional async callback when Continue button is pressed
/// - [onDismissed]: Optional callback when modal is dismissed/closed
///
/// Example:
/// ```dart
/// OttModal.show(
///   context: context,
///   ott: 'abc123...',
///   onContinue: () async => await context.continuePayment(),
///   onDismissed: () => _lastProcessedToken = null,
/// );
/// ```
class OttModal {
  // Static flag to prevent multiple modals
  static bool _isShowing = false;

  static Future<void> show({
    required BuildContext context,
    required String ott,
    Future<void> Function()? onContinue,
    VoidCallback? onDismissed,
  }) {
    // Prevent showing multiple modals
    if (_isShowing) {
      return Future.value();
    }

    _isShowing = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'OTT Received',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _isShowing = false;
                        Navigator.of(dialogContext).pop();
                        onDismissed?.call();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'OTT:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ott,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: ott));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTT copied to clipboard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _isShowing = false;
                        Navigator.of(dialogContext).pop();
                        onDismissed?.call();
                      },
                      child: const Text('Cerrar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        // Cerrar el modal primero
                        _isShowing = false;
                        Navigator.of(dialogContext).pop();
                        onDismissed?.call();
                        // Ejecutar el callback después de cerrar
                        if (onContinue != null) {
                          // Pequeño delay para asegurar que el modal se cerró
                          await Future.delayed(const Duration(milliseconds: 50));
                          await onContinue();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Continuar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Reset flag when dialog is closed (in case it's closed by other means)
      _isShowing = false;
      onDismissed?.call();
    });
  }
}
