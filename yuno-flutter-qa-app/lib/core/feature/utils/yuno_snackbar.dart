import 'package:flutter/material.dart';
import 'package:yuno/yuno.dart';

enum YunoSnackbarOptions {
  enrollment,
  payment,
}

class YunoSnackBar {
  static void showSnackBar(
    context,
    YunoSnackbarOptions option,
    YunoStatus? status,
    VoidCallback doSomething,
  ) {
    switch (status) {
      case null:
        return;
      case YunoStatus.reject:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${option.name} rejected ❌'),
            backgroundColor: Colors.redAccent,
          ),
        );
        doSomething();
        return;
      case YunoStatus.succeeded:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
                child: Text(
              '${option.name} Success ✅',
              style: const TextStyle(
                color: Colors.black,
              ),
            )),
            backgroundColor: Colors.greenAccent,
          ),
        );
        doSomething();
        return;
      case YunoStatus.fail:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong ❌'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
      case YunoStatus.processing:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Processing ...'),
            backgroundColor: Colors.yellowAccent,
          ),
        );
        doSomething();
        return;
      case YunoStatus.internalError:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internal error 🤔'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
      case YunoStatus.cancelByUser:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${option.name} had been canceled 😢'),
            backgroundColor: Colors.red,
          ),
        );
        doSomething();
        return;
    }
  }
}
