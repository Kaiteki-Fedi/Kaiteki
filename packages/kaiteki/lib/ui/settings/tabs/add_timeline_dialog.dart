import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/lists.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";

class AddTimelineDialog extends StatefulWidget {
  const AddTimelineDialog({super.key});

  @override
  State<AddTimelineDialog> createState() => _AddTimelineDialogState();
}

final _noHashtags = FilteringTextInputFormatter.deny(r"#");

class _AddTimelineDialogState extends State<AddTimelineDialog> {
  TimelineSourceType _type = TimelineSourceType.hashtag;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add timeline"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_type);
            }
          },
          child: const Text("Add"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Focus(
              autofocus: true,
              child: DropdownMenu(
                label: const Text("Type"),
                requestFocusOnTap: false,
                initialSelection: _type,
                onSelected: (value) {
                  setState(() => _type = value!);
                },
                dropdownMenuEntries: [
                  const DropdownMenuEntry(
                    value: TimelineSourceType.user,
                    label: "User",
                    leadingIcon: Icon(Icons.person_rounded),
                  ),
                  const DropdownMenuEntry(
                    value: TimelineSourceType.list,
                    label: "List",
                    leadingIcon: Icon(Icons.article_rounded),
                  ),
                  const DropdownMenuEntry(
                    value: TimelineSourceType.hashtag,
                    label: "Hashtag",
                    leadingIcon: Icon(Icons.tag_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            switch (_type) {
              TimelineSourceType.user => throw UnimplementedError(),
              TimelineSourceType.standard => throw AssertionError(
                  "Standard timelines shouldn't be selectable"),
              TimelineSourceType.list => ListSelection(),
              TimelineSourceType.hashtag => TextFormField(
                  decoration: const InputDecoration(
                    prefixText: "#",
                    labelText: "Hashtag",
                    hintText: "cats",
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [_noHashtags],
                ),
            }
          ],
        ),
      ),
    );
  }
}

class ListSelection extends ConsumerWidget {
  const ListSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountKey = ref.watch(currentAccountProvider.select((e) => e!.key));
    final listsService = ref.watch(listsServiceProvider(accountKey));
    return listsService.when(
      data: (data) {
        return DropdownMenu<String?>(
          label: const Text("List"),
          dropdownMenuEntries: data
              .map(
                (e) => DropdownMenuEntry(
                  value: e.id,
                  label: e.name,
                  leadingIcon: const Icon(Icons.article_rounded),
                ),
              )
              .toList(),
        );
      },
      error: (error, stackTrace) {
        return DropdownMenu(
          label: const Text("List"),
          dropdownMenuEntries: [],
          enabled: false,
        );
      },
      loading: () {
        return DropdownMenu(
          label: const Text("List"),
          dropdownMenuEntries: [],
          enabled: false,
        );
      },
    );
  }
}
