import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/configuration/presenter/ios_configuration_screen.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:example/features/configuration/presenter/screen/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const logo = 'https://colombiafintech.co/static/uploads/logo_yuno_morado.png';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBar(
        customHeight: 160,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Consumer(
              builder: (context, ref, child) {
                final controller = ref.watch(credentialNotifier);

                return controller.when(
                  data: (credential) {
                    if (credential.alias.isEmpty ||
                        credential.countryCode.isEmpty ||
                        credential.apiKey.isEmpty) {
                      return const RegisterCard();
                    } else {
                      return Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) async {
                                await ref.read(providerStorage).removeAll();
                                final _ =
                                    ref.refresh(credentialNotifier.future);

                                ref.invalidate(langNotifier);
                                ref.invalidate(cardFlowNotifier);
                                ref.invalidate(appearanceNotifier);
                                ref.invalidate(contryCodeNotifier);
                                ref.invalidate(saveCardNotifier);
                                ref.invalidate(keepLoaderNotifier);
                                ref.invalidate(dynamicSDKNotifier);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConfigurationScreen())),
                            title: Text(
                              credential.alias,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              credential.apiKey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  error: (err, stk) => const RegisterCard(),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class RegisterCard extends StatelessWidget {
  const RegisterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ShowBottomDialog.show(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        color: Colors.white,
        child: const SizedBox(
          height: 50,
          width: 350,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.key),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Add a custom API Key',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Override preferredSize

  CustomNavigationBar({
    super.key,
    this.customHeight = 60.0,
  }) : preferredSize = Size.fromHeight(customHeight);

  final double customHeight;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(customHeight),
      child: Container(
        color: Colors.white,
        height: customHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 110,
                ),
                Row(
                  children: [
                    Image.network(
                      logo,
                      scale: 14,
                      fit: BoxFit.contain,
                    ),
                    const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    const FlutterLogo(
                      size: 35,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowBottomDialog {
  static Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 650,
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                SizedBox(
                  height: 10,
                ),
                RegisterForm(),
                Spacer(),
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

class FontListName extends ConsumerStatefulWidget {
  const FontListName({
    super.key,
    required this.controller,
  });
  final ScrollController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FontListNameState();
}

class _FontListNameState extends ConsumerState<FontListName> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.controller,
      itemCount: fontNames.length,
      itemBuilder: (context, index) => ListTile(
        leading: Checkbox(
          value: selectedIndex == index,
          onChanged: (value) async {
            setState(() {
              selectedIndex = value! ? index : null;
            });

            await ref.read(providerStorage).write(
                  key: Keys.fontFamily.name,
                  value: fontNames[index],
                );
          },
        ),
        title: Text(fontNames[index]),
      ),
      separatorBuilder: (context, index) => const Divider(
        thickness: 0.5,
        height: 0,
      ),
    );
  }
}

List<String> fontNames = [
  "Academy Engraved LET",
  "Al Nile",
  "American Typewriter",
  "Apple Color Emoji",
  "Apple SD Gothic Neo",
  "Arial",
  "Arial Rounded MT Bold",
  "Avenir",
  "Avenir Next",
  "Avenir Next Condensed",
  "Baskerville",
  "Bodoni 72",
  "Bodoni 72 Oldstyle",
  "Bodoni 72 Smallcaps",
  "Bradley Hand",
  "Chalkboard SE",
  "Chalkduster",
  "Cochin",
  "Copperplate",
  "Courier",
  "Courier New",
  "DIN Alternate",
  "DIN Condensed",
  "Damascus",
  "Devanagari Sangam MN",
  "Didot",
  "Diwan Kufi",
  "Diwan Thuluth",
  "Euphemia UCAS",
  "Farah",
  "Futura",
  "Geeza Pro",
  "Georgia",
  "Gill Sans",
  "Gujarati Sangam MN",
  "Gurmukhi MN",
  "Helvetica",
  "Helvetica Neue",
  "Hiragino Maru Gothic ProN",
  "Hiragino Mincho ProN",
  "Hoefler Text",
  "Kailasa",
  "Kannada Sangam MN",
  "Khmer Sangam MN",
  "Kohinoor Bangla",
  "Kohinoor Devanagari",
  "Kohinoor Gujarati",
  "Kohinoor Telugu",
  "Lao Sangam MN",
  "Malayalam Sangam MN",
  "Marker Felt",
  "Menlo",
  "Mishafi",
  "Myanmar Sangam MN",
  "Noteworthy",
  "Optima",
  "Oriya Sangam MN",
  "Palatino",
  "Papyrus",
  "Party LET",
  "PingFang HK",
  "PingFang SC",
  "PingFang TC",
  "Rockwell",
  "Savoye LET",
  "Sinhala Sangam MN",
  "Snell Roundhand",
  "Symbol",
  "Tamil Sangam MN",
  "Telugu Sangam MN",
  "Thonburi",
  "Times New Roman",
  "Trebuchet MS",
  "Verdana",
  "Zapf Dingbats",
  "Zapfino"
];
