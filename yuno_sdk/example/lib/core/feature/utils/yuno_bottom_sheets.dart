import 'package:example/core/feature/utils/yuno_dialogs.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/screen/home.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowBottomDialog {
  static Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 720,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    'Add API Key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: const [
                      RegisterForm(),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future showFontsList(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF2F2F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          minChildSize: 0.7,
          initialChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return Consumer(
              builder: (context, ref, child) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Fonts Avialable',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 30),
                                child: FontListName(
                                  controller: controller,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static Future showAppearence(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF2F2F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          minChildSize: 0.7,
          initialChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              controller: controller,
              child: Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text(
                          'Apprearence',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'ACCENT COLOR',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Accent Color',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            final color = await YunoDiaglos
                                                .showPickerColor(
                                                    context: context);
                                            if (color != null) {
                                              ref
                                                  .read(providerStorage)
                                                  .writeInt(
                                                    key: Keys.accentColor.name,
                                                    value: color.value,
                                                  );
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.colorize_rounded))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'BUTTON COLORS',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'BACKGROUND COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .buttonBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'TITLE COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .buttonTitleBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'BORDER COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .buttonBorderBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'SECONDARY BUTTON COLORS',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'BACKGROUND COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .secondaryButtonBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'TITLE COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .secondaryButtonTitleBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'BORDER COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .secondaryButtonBorderBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'DISABLE BUTTON COLORS',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'BACKGROUND COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .disableButtonBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'TITLE COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .disableButtonTitleBackgrounColor
                                                            .name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'CHECKBOX COLORS',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'CHECKBOX COLOR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                final color = await YunoDiaglos
                                                    .showPickerColor(
                                                        context: context);
                                                if (color != null) {
                                                  ref
                                                      .read(providerStorage)
                                                      .writeInt(
                                                        key: Keys
                                                            .checkboxColor.name,
                                                        value: color.value,
                                                      );
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.colorize_rounded))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
