import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/embedded_post.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";

const _kBasicInformationPageIndex = 0;
const _kAdditionalInformationPageIndex = 1;
const _kConfirmReportPageIndex = 2;

class ReportDialog extends ConsumerStatefulWidget {
  final User user;
  final List<Post> posts;

  const ReportDialog({
    super.key,
    required this.user,
    this.posts = const [],
  });

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  int _currentStep = _kBasicInformationPageIndex;
  bool _includePosts = true;
  bool _forward = false;
  final _additionalInformationFormKey = GlobalKey<FormState>();
  late final TextEditingController _commentController;

  bool get isLastStep => _currentStep >= _kConfirmReportPageIndex;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPosts = widget.posts.isNotEmpty;
    final handle = widget.user.handle.toString();
    final account = ref.watch(currentAccountProvider);
    final adapter = account?.adapter.safeCast<ReportSupport>();

    if (adapter == null) {
      return AlertDialog(
        title: const Text("Filing reports is not possible"),
        content:
            Text("${account!.key.host} does not support receiving reports."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.materialL10n.okButtonLabel),
          ),
        ],
      );
    }

    final commentLengthLimit = adapter.capabilities.reportCommentLengthLimit;
    final stepper = Stepper(
      onStepContinue: _onStepContinue,
      currentStep: _currentStep,
      onStepTapped: (value) => setState(() => _currentStep = value),
      onStepCancel: _onCancel,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              FilledButton(
                onPressed: details.onStepContinue,
                child: details.stepIndex >= 2
                    ? Text(context.l10n.submitButtonTooltip)
                    : Text(context.materialL10n.continueButtonLabel),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: details.onStepCancel,
                child: Text(context.materialL10n.cancelButtonLabel),
              ),
            ],
          ),
        );
      },
      steps: [
        Step(
          title: const Text("Basic information"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("You are about to report $handle."),
              if (hasPosts) ...[
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _includePosts,
                  onChanged: (value) => setState(() => _includePosts = value!),
                  title: const Text("Include user's post(s)"),
                ),
                if (widget.posts.length == 1 && _includePosts)
                  EmbeddedPostWidget(widget.posts.first),
              ],
            ],
          ),
        ),
        Step(
          title: const Text("Additional information"),
          content: Form(
            key: _additionalInformationFormKey,
            child: Padding(
              // need to offset so it doesn't clip the floating label
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _commentController,
                autofocus: true,
                minLines: 3,
                maxLines: null,
                maxLength: commentLengthLimit,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                validator: (value) {
                  if (value != null) {
                    if (commentLengthLimit != null && value.length > commentLengthLimit) {
                      return "Comment must be less than $commentLengthLimit characters";
                    }
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Comment",
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ),
        ),
        Step(
          title: const Text("Confirm report"),
          content: Column(
            children: [
              ListTile(
                leading: AvatarWidget(widget.user, size: 40.0),
                title: const Text("User to be reported"),
                subtitle: Text(widget.user.handle.toString()),
                contentPadding: EdgeInsets.zero,
              ),
              if (hasPosts)
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.article_rounded),
                  ),
                  title: const Text("Posts to be included"),
                  subtitle: _includePosts
                      ? Text("${widget.posts.length} posts")
                      : const Text("None"),
                  contentPadding: EdgeInsets.zero,
                ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.short_text_rounded),
                ),
                title: const Text("Comment"),
                subtitle: ListenableBuilder(
                  listenable: _commentController,
                  builder: (_, __) => Text(
                    _commentController.text.trim().isEmpty
                        ? "No comment"
                        : _commentController.text,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              if (widget.user.host != account!.key.host) ...[
                const Divider(),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _forward,
                  onChanged: (value) => setState(() => _forward = value!),
                  isThreeLine: true,
                  title: Text("Forward to ${widget.user.host}"),
                  subtitle: Text(
                      "Your report is also sent to ${widget.user.host}. This can be a risk if the administration team of ${widget.user.host} is malicious.",),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact) {
      return PopScope(
        canPop: false,
        onPopInvoked: _onPopInvoked,
        child: Scaffold(
          appBar: AppBar(title: const Text("File a report")),
          body: stepper,
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Dialog(
        child: ConstrainedBox(
          constraints: kDialogConstraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, top: 24.0 - 4.0, right: 24.0 - 4.0,),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "File a report",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: _onCancel,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(child: stepper),
            ],
          ),
        ),
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep >= _kAdditionalInformationPageIndex) {
      final isFormValid =
          _additionalInformationFormKey.currentState?.validate();
      if (isFormValid != true) {
        return;
      }
    }

    if (isLastStep) {
      _onSubmit();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _onPopInvoked(didPop) {
    if (didPop) return;
    _onCancel();
  }

  Future<void> _onSubmit() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final adapter = ref.read(adapterProvider);
    final reportInterface = adapter as ReportSupport;
    final capabilities = adapter.capabilities as ReportCapabilities;

    var comment = _commentController.text;

    if (_includePosts && !capabilities.canIncludePosts) {
      final postUrls = widget.posts.map((e) => e.externalUrl);
      comment += "\n\n${postUrls.join("\n")}";
    }

    reportInterface
        .submitReport(
      userId: widget.user.id,
      comment: comment,
      forwardToRemoteInstance: _forward,
      postIds: widget.posts.map((e) => e.id).toList(growable: false),
    ).then((_) {
      const snackBar = SnackBar(
        content: Text("Report submitted successfully"),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    }).catchError((error, stackTrace) {
      const snackBar = SnackBar(
        content: Text("Report couldn't be submitted"),
      );

      scaffoldMessenger.showSnackBar(snackBar);

      Logger("ReportDialog")
          .warning("Report couldn't be submitted", error, stackTrace);
    });

    Navigator.of(context).pop();
  }

  Future<void> _onCancel() async {
    final navigator = Navigator.of(context);

    final result = await showDialog(
      context: context,
      builder: (context) {
        final materialL10n = context.materialL10n;
        return AlertDialog(
          title: const Text("Discard report?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(materialL10n.cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.discardButtonLabel),
            ),
          ],
        );
      },
    );

    if (result == true) navigator.pop();
  }
}
