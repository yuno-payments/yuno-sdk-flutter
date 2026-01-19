import 'package:example/core/feature/utils/yuno_bottom_sheets.dart';
import 'package:example/core/feature/credential/domain/entity/credential/credential.dart';
import 'package:example/core/feature/bootstrap/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:example/core/helpers/keys.dart';
import 'package:example/core/helpers/secure_storage_helper.dart';
import 'package:example/features/home/presenter/widget/register_form.dart';
import 'package:example/features/configuration/presenter/screen/setup_screen.dart';
import 'package:example/features/home/presenter/screen/automation_screen.dart';
import 'package:example/features/configuration/presenter/widgets/version_footer.dart';
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
      body: Consumer(
        builder: (context, ref, child) {
          final credentialsList = ref.watch(credentialsListNotifier);
          final currentCredential = ref.watch(credentialNotifier);

          return credentialsList.when(
            data: (credentials) {
              if (credentials.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const VersionFooter(),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RegisterCard(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AutomationScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings_applications),
                          label: const Text('Automation'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  const VersionFooter(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: credentials.length,
                      itemBuilder: (context, index) {
                        final credential = credentials[index];
                        final isCurrent = currentCredential.maybeWhen(
                          data: (current) =>
                              current.alias == credential.alias,
                          orElse: () => false,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Slidable(
                            key: ValueKey(credential.alias),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) async {
                                    final updatedCredentials =
                                        List<Credential>.from(credentials);
                                    updatedCredentials.removeAt(index);
                                    await ref
                                        .read(providerStorage)
                                        .saveCredentials(updatedCredentials);
                                    if (isCurrent &&
                                        updatedCredentials.isNotEmpty) {
                                      await ref
                                          .read(providerStorage)
                                          .setCurrentCredential(
                                              updatedCredentials.first);
                                    } else if (updatedCredentials.isEmpty) {
                                      await ref
                                          .read(providerStorage)
                                          .removeAll();
                                    }
                                    ref.refresh(credentialsListNotifier.future);
                                    ref.refresh(credentialNotifier.future);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              color: isCurrent
                                  ? Colors.blue.shade50
                                  : Colors.white,
                              elevation: 0,
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  await ref
                                      .read(providerStorage)
                                      .setCurrentCredential(credential);
                                  ref.invalidate(credentialNotifier);
                                  ref.invalidate(yunoProvider);
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SetUpScreen(),
                                      ),
                                    );
                                  }
                                },
                                onLongPress: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Key'),
                                      content: Text(
                                        'Are you sure you want to delete "${credential.alias}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldDelete == true && context.mounted) {
                                    final updatedCredentials =
                                        List<Credential>.from(credentials);
                                    updatedCredentials.removeAt(index);
                                    await ref
                                        .read(providerStorage)
                                        .saveCredentials(updatedCredentials);
                                    if (isCurrent &&
                                        updatedCredentials.isNotEmpty) {
                                      await ref
                                          .read(providerStorage)
                                          .setCurrentCredential(
                                              updatedCredentials.first);
                                    } else if (updatedCredentials.isEmpty) {
                                      await ref
                                          .read(providerStorage)
                                          .removeAll();
                                    }
                                    ref.refresh(credentialsListNotifier.future);
                                    ref.refresh(credentialNotifier.future);
                                  }
                                },
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
                                trailing: isCurrent
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          child: ElevatedButton.icon(
                            onPressed: () => ShowBottomDialog.show(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add API Key'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 350,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AutomationScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings_applications),
                            label: const Text('Automation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (err, stk) => const Center(
              child: RegisterCard(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
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
  final Size preferredSize; 

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
        child: const Center(
          child: const Padding(
            padding: const EdgeInsets.only(top: 110),
            child: const Text(
              'Yuno Flutter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
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
