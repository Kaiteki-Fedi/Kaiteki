import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/report_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class ReportDialog extends ConsumerStatefulWidget {
  final User user;
  final List<Post> posts;

  const ReportDialog({
    Key? key,
    required this.user,
    this.posts = const [],
  }) : super(key: key);

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  var sendCopyToRemoteInstance = false;
  final _detailsController = TextEditingController();
  late List<bool> _selectedPosts;

  @override
  void initState() {
    _selectedPosts = List<bool>.filled(widget.posts.length, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final capabilities = adapter.capabilities is ReportSupportCapabilities
        ? adapter.capabilities as ReportSupportCapabilities
        : null;
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        return ConstrainedBox(
          constraints: dialogConstraints,
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text.rich(
                    TextSpan(
                      text: "Report ",
                      children: [widget.user.renderDisplayName(context, ref)],
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text("You're reporting ${widget.user.handle}"),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _detailsController,
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: "Details",
                            hintText: "What's wrong with this user?",
                            border: const OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 5,
                          maxLength: capabilities?.maxReportCommentLength,
                        ),
                        const SizedBox(height: 12),
                        ExpansionTile(
                          title: const Text("Related posts"),
                          subtitle: Text(
                            "${_selectedPosts.where((e) => e).length} post(s) selected",
                          ),
                          initiallyExpanded: widget.posts.isNotEmpty,
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            for (var i = 0; i < widget.posts.length; i++)
                              CheckboxListTile(
                                value: _selectedPosts[i],
                                onChanged: (v) => setState(() {
                                  _selectedPosts[i] = v!;
                                }),
                                title: DefaultTextStyle(
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                  child: PostWidget(
                                    widget.posts[i],
                                    showActions: false,
                                    hideAvatar: true,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            // ListTile(
                            //   title: Text("Add a post"),
                            //   leading: const Icon(Icons.add_rounded),
                            // ),
                          ],
                        ),
                        CheckboxListTile(
                          value: sendCopyToRemoteInstance,
                          onChanged: (v) => setState(
                            () => sendCopyToRemoteInstance = v!,
                          ),
                          title: const Text(
                            "Send a copy of this report to the remote instance",
                          ),
                          subtitle: const Text(
                            "Check this if you want action to be taken on the remote instance",
                          ),
                          isThreeLine: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.error,
                              onPrimary: Theme.of(context).colorScheme.onError,
                            ),
                            onPressed: () {},
                            child: const Text("Report"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
