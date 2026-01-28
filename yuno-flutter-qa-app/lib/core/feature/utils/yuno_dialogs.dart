import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:yuno/yuno.dart';

class YunoDiaglos {
  static Future<CardFlow?> showCardStep({
    required BuildContext context,
  }) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Card Flow"),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, CardFlow.values[index]),
                      child: Center(
                        child: Text(CardFlow.values[index].name),
                      ),
                    );
                  },
                  itemCount: CardFlow.values.length,
                ),
              )
            ],
          );
        },
      );
  static Future<YunoLanguage?> show({
    required BuildContext context,
  }) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select a language"),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, YunoLanguage.values[index]),
                      child: Center(
                        child: Text(YunoLanguage.values[index].rawValue),
                      ),
                    );
                  },
                  itemCount: YunoLanguage.values.length,
                ),
              )
            ],
          );
        },
      );

  static Future<Color?> showPickerColor({required BuildContext context}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        Color? color;
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.black,
              onColorChanged: (value) {
                color = value;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop(color);
              },
            ),
          ],
        );
      },
    );
  }
}
