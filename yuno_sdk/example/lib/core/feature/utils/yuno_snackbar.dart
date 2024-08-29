import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

class YunoSnackBar {
  static void showSnackBar(
      context, PaymentStatus? status, VoidCallback doSomething) {
    switch (status) {
      case null:
        return;
      case PaymentStatus.reject:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment rejected ❌'),
            backgroundColor: Colors.redAccent,
          ),
        );
        doSomething();
        return;
      case PaymentStatus.succeded:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
                child: Text(
              'Success ✅',
              style: TextStyle(
                color: Colors.black,
              ),
            )),
            backgroundColor: Colors.greenAccent,
          ),
        );
        doSomething();
        return;
      case PaymentStatus.fail:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong ❌'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
      case PaymentStatus.processing:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Processing ...'),
            backgroundColor: Colors.yellowAccent,
          ),
        );
        doSomething();
        return;
      case PaymentStatus.internalError:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internal error 🤔'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
      case PaymentStatus.cancel:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction had been canceled 😢'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
    }
  }
}
