import "dart:convert";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/services/mutes.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/utils/extensions.dart";

class MutesScreen extends ConsumerStatefulWidget {
  const MutesScreen({super.key});

  @override
  ConsumerState<MutesScreen> createState() => _MutesScreenState();
}

class _MutesScreenState extends ConsumerState<MutesScreen> {
  late final PagingController<bool, User> _controller;

  @override
  void initState() {
    super.initState();

    final accountKey = ref.read(accountProvider)!.key;
    final mutesService = mutesServiceProvider(accountKey);

    // FIXME(Craftplacer): MutesScreen isn't listening for changes
    _controller = PagingController<bool, User>(firstPageKey: true)
      ..addPageRequestListener((isFirstPage) async {
        if (!mounted) return;
        if (isFirstPage) {
          ref.read(mutesService);
        } else {
          ref.read(mutesService.notifier).loadMore();
        }
      });

    ref.listenManual(
      mutesService,
      (_, value) => _controller.value = value.getPagingState(false),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Mutes"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(onTap: _onImport, child: const Text("Import")),
            ];
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: PagedListView<void, User>(
        pagingController: _controller,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            return UserListTile(
              user: item,
              trailing: [
                FilledButton.tonal(
                  onPressed: () async {
                    final account = ref.read(accountProvider)!;
                    final mutesProvider = mutesServiceProvider(account.key);
                    await ref.read(mutesProvider.notifier).unmute(item.id);
                  },
                  child: const Text("Unmute"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onImport() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Import mute list",
      type: FileType.custom,
      allowedExtensions: ["csv"],
      withReadStream: true,
    );

    if (result == null) return;

    final file = result.files.first;
    final csv = await utf8.decodeStream(file.readStream!);
    final list = csv.split("\n");

    if (!mounted) return;

    final valueNotifier = ValueNotifier<double?>(null);

    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ValueListenableBuilder(
                    builder: (context, value, _) {
                      return CircularProgressIndicator(value: value);
                    },
                    valueListenable: valueNotifier,
                  ),
                  const SizedBox(width: 24),
                  const Text("Importing mutes..."),
                ],
              ),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );

    final account = ref.read(accountProvider)!;
    final mutesProvider = mutesServiceProvider(account.key);

    try {
      // await Future.delayed(const Duration(seconds: 2));

      final stream = ref.read(mutesProvider.notifier).muteBatch(list.toSet());

      await for (final progress in stream) {
        valueNotifier.value = progress / list.length;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Muted ${list.length} users"),
          ),
        );
      }
    } catch (e, s) {
      if (mounted) {
        context.showErrorSnackbar(
          text: const Text("Failed to import mutes"),
          error: e,
          stackTrace: s,
        );
      }
    } finally {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
