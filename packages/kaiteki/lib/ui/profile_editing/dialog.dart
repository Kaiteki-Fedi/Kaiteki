import "dart:ui";

import "package:cross_file_image/cross_file_image.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

class EditProfileDialog extends StatefulWidget {
  final ProfileSettings settings;

  const EditProfileDialog({
    super.key,
    required this.settings,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController _displayNameController,
      _descriptionController,
      _newFieldKeyController,
      _newFieldValueController;
  late TabController _tabController;
  late DateTime? _birthday;
  late final List<(TextEditingController, TextEditingController)>
      _profileFieldControllers;
  ImageProvider? _avatarImage, _bannerImage, _backgroundImage;
  bool _isChangingPictures = false;
  final _picturesKey = GlobalKey<_ChangeProfilePicturesBodyState>();

  bool get isAvatarModified {
    final originalAvatarUrl = widget.settings.avatarUrl;

    final avatarImage = _avatarImage;
    return originalAvatarUrl != null &&
        (avatarImage is NetworkImage &&
            avatarImage.url != originalAvatarUrl.toString());
  }

  bool get isProfileModified {
    return true;
  }

  bool get isModified {
    return isAvatarModified || isProfileModified;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    final settings = widget.settings;
    _displayNameController = TextEditingController(
      text: settings.displayName,
    );
    _descriptionController = TextEditingController(
      text: settings.description,
    );
    _birthday = settings.birthday;
    _newFieldKeyController = TextEditingController();
    _newFieldValueController = TextEditingController();

    final fields = settings.fields;
    _profileFieldControllers = [
      if (fields != null)
        for (final kv in fields)
          (
            TextEditingController(text: kv.key),
            TextEditingController(text: kv.value),
          ),
    ];

    _avatarImage =
        settings.avatarUrl?.andThen((e) => NetworkImage(e.toString()));

    _bannerImage =
        settings.bannerUrl?.andThen((e) => NetworkImage(e.toString()));

    _backgroundImage =
        settings.backgroundUrl?.andThen((e) => NetworkImage(e.toString()));
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: _tabController,
      tabs: const [Tab(text: "Basics"), Tab(text: "Fields")],
    );

    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;
    final theme = Theme.of(context);
    final background = ElevationOverlay.applySurfaceTint(
      theme.colorScheme.surface,
      theme.colorScheme.surfaceTint,
      isCompact ? 0.0 : 6.0,
    );

    final mainBody = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isCompact) tabBar,
        Flexible(
          child: SizedBox(
            width: isCompact ? null : kDialogConstraints.maxWidth,
            height: isCompact ? null : kDialogConstraints.maxWidth,
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      _ProfilePicturesHeader(
                        avatarImage: _avatarImage,
                        bannerImage: _bannerImage,
                        onChangePictures: _onChangePictures,
                      ),
                      const SizedBox(height: 16),
                      _DisplayNameField(
                        controller: _displayNameController,
                      ),
                      const SizedBox(height: 16),
                      _DescriptionField(
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InputDatePickerFormField(
                              firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                              lastDate: DateTime.now(),
                              acceptEmptyDate: true,
                              fieldLabelText: "Birthday",
                              initialDate: _birthday,
                              onDateSaved: (value) {
                                setState(() => _birthday = value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Pronouns",
                                hintText: "they/them",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.manage_accounts_rounded),
                        title: const Text("Account Settings"),
                        onTap: () {
                          context.pushNamed(
                            "accountSettings",
                            pathParameters: ProviderScope.containerOf(context)
                                .read(currentAccountProvider)!
                                .key
                                .routerParams,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _ProfileFieldsPage(
                  profileFieldControllers: _profileFieldControllers,
                  newFieldKeyController: _newFieldKeyController,
                  newFieldValueController: _newFieldValueController,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final pictureChangeBody = _ChangeProfilePicturesBody(
      key: _picturesKey,
      isCompact: isCompact,
      background: background,
      avatarImage: _avatarImage,
      bannerImage: _bannerImage,
      backgroundImage: _backgroundImage,
    );

    final body = AnimatedSize(
      clipBehavior: Clip.none,
      duration: Durations.medium3,
      alignment: Alignment.topCenter,
      curve: Curves.easeInOutCubicEmphasized,
      child: AnimatedSwitcher(
        duration: Durations.long1,
        switchInCurve: Curves.easeInOutCubicEmphasized,
        switchOutCurve: Curves.easeInOutCubicEmphasized,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: _isChangingPictures ? pictureChangeBody : mainBody,
      ),
    );

    final saveButton = TextButton(
      onPressed: isModified ? _onSave : null,
      child: Text(context.materialL10n.saveButtonLabel),
    );

    final title = AnimatedSwitcher(
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      duration: Durations.short3,
      child: _isChangingPictures
          ? const Text(key: ValueKey(1), "Change profile pictures")
          : const Text(key: ValueKey(0), "Edit profile"),
    );

    Widget child = body;

    if (isCompact) {
      child = Scaffold(
        appBar: AppBar(
          title: title,
          actions: [saveButton],
          bottom: _isChangingPictures ? null : tabBar,
        ),
        body: child,
      );
    } else {
      child = AlertDialog(
        contentPadding: const EdgeInsets.only(bottom: 16.0),
        content: ConstrainedBox(
          constraints: kDialogConstraints,
          child: child,
        ),
        semanticLabel: context.materialL10n.dialogLabel,
        title: title,
        actions: [
          const CancelTextButton(),
          saveButton,
        ],
      );
    }

    return PopScope(
      canPop: !_isChangingPictures,
      onPopInvoked: (didPop) {
        if (!didPop) _onCancel();
      },
      child: child,
    );
  }

  void _onChangePictures() {
    setState(() => _isChangingPictures = true);
  }

  void _onCancel() {
    if (_isChangingPictures) {
      setState(() => _isChangingPictures = false);
    }
  }

  Future<void> _onSave() async {
    if (_isChangingPictures) {
      final pictures = _picturesKey.currentState!.pictures;

      _avatarImage = pictures.avatar;
      _backgroundImage = pictures.background;
      _bannerImage = pictures.banner;

      setState(() {
        _isChangingPictures = false;
      });

      return;
    }

    final navigator = Navigator.of(context);
    final adapter = ProviderScope.containerOf(context).read(adapterProvider);

    if (isProfileModified) {
      const profileSettings = ProfileSettings(description: "");
      await adapter.setProfileSettings(profileSettings);
    }

    final avatarImage = _avatarImage;
    if (isAvatarModified && avatarImage is XFileImage) {
      await adapter.setAvatar(avatarImage.file);
    }

    navigator.pop();
  }
}

class _ChangePicturesButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ChangePicturesButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_rounded, size: 18),
      label: const Text("Change pictures"),
      style: TextButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.primary,
        visualDensity: VisualDensity.standard,
        elevation: 1.0,
      ),
    );
  }
}

class _ProfileFieldsPage extends StatelessWidget {
  const _ProfileFieldsPage({
    required this.profileFieldControllers,
    required this.newFieldKeyController,
    required this.newFieldValueController,
  });

  final List<(TextEditingController, TextEditingController)>
      profileFieldControllers;
  final TextEditingController newFieldKeyController;
  final TextEditingController newFieldValueController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 16.0),
      slivers: [
        SliverReorderableList(
          itemBuilder: (context, index) {
            return _ProfileFieldRow(
              key: ValueKey(index),
              keyController: profileFieldControllers[index].$1,
              valueController: profileFieldControllers[index].$2,
              index: index,
            );
          },
          itemCount: profileFieldControllers.length,
          onReorder: (oldIndex, newIndex) {},
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final animValue = Curves.easeInOut.transform(animation.value);
                final elevation = lerpDouble(0, 6, animValue)!;
                return Material(elevation: elevation, child: child);
              },
              child: child,
            );
          },
        ),
        SliverToBoxAdapter(
          child: _ProfileFieldRow(
            keyController: newFieldKeyController,
            valueController: newFieldValueController,
          ),
        ),
      ],
    );
  }
}

class _ChangeProfilePicturesBody extends StatefulWidget {
  const _ChangeProfilePicturesBody({
    super.key,
    required this.isCompact,
    required this.background,
    required this.avatarImage,
    required this.bannerImage,
    required this.backgroundImage,
  });

  final bool isCompact;
  final Color background;
  final ImageProvider? avatarImage;
  final ImageProvider? bannerImage;
  final ImageProvider? backgroundImage;

  @override
  State<_ChangeProfilePicturesBody> createState() =>
      _ChangeProfilePicturesBodyState();
}

class _ChangeProfilePicturesBodyState
    extends State<_ChangeProfilePicturesBody> {
  ImageProvider? _avatarImage, _bannerImage, _backgroundImage;
  static final _picker = ImagePicker();

  ({
    ImageProvider? avatar,
    ImageProvider? banner,
    ImageProvider? background,
  }) get pictures {
    return (
      avatar: _avatarImage,
      banner: _bannerImage,
      background: _backgroundImage,
    );
  }

  @override
  void initState() {
    super.initState();
    _avatarImage = widget.avatarImage;
    _bannerImage = widget.bannerImage;
    _backgroundImage = widget.backgroundImage;
  }

  @override
  Widget build(BuildContext context) {
    final bannerColumn = _WidescreenProfilePictureColumn(
      image: _bannerImage,
      header: const Text("Banner"),
      onChange: _onChangeBanner,
      onRemove: _onRemoveBanner,
    );

    final backgroundColumn = _WidescreenProfilePictureColumn(
      image: _backgroundImage,
      header: const Text("Background"),
      onChange: _onChangeBackground,
      onRemove: _onRemoveBackground,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Subheader(Text("Avatar"), padding: EdgeInsets.zero),
          _ProfileAvatarRow(
            image: _avatarImage,
            onChangeAvatar: _onChangeAvatar,
            onRemoveAvatar: _onRemoveAvatar,
            center: !widget.isCompact,
          ),
          const SizedBox(height: 16),
          if (widget.isCompact) ...[bannerColumn, backgroundColumn] else
            Row(
              children: [
                Expanded(child: bannerColumn),
                const SizedBox(width: 16),
                Expanded(child: backgroundColumn),
              ],
            ),
        ],
      ),
    );
  }

  void _onRemoveBanner() {
    setState(() => _bannerImage = null);
  }

  void _onRemoveAvatar() {
    setState(() => _avatarImage = null);
  }

  Future<void> _onChangeBackground() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (image == null) return;

    setState(() {
      _backgroundImage = XFileImage(image);
    });
  }

  Future<void> _onChangeAvatar() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (image == null) return;

    setState(() {
      _avatarImage = XFileImage(image);
    });
  }

  Future<void> _onChangeBanner() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (image == null) return;

    setState(() {
      _bannerImage = XFileImage(image);
    });
  }

  void _onRemoveBackground() => setState(() => _backgroundImage = null);
}

class _ProfileAvatarRow extends StatelessWidget {
  const _ProfileAvatarRow({
    required this.image,
    this.onRemoveAvatar,
    this.onChangeAvatar,
    this.center = true,
  });

  final bool center;
  final ImageProvider? image;
  final VoidCallback? onRemoveAvatar;
  final VoidCallback? onChangeAvatar;

  @override
  Widget build(BuildContext context) {
    final avatarImage = image;

    final buttonStyle = FilledButton.styleFrom(
      visualDensity: VisualDensity.standard,
    );

    return Row(
      children: [
        if (!center) ...[
          const Expanded(child: SizedBox()),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Center(
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.black12),
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: ClipOval(
                    child: SizedBox.square(
                      dimension: 144.0,
                      child: avatarImage == null
                          ? null
                          : Image(image: avatarImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton.outlined(
                    onPressed: onRemoveAvatar,
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: onChangeAvatar,
                    style: buttonStyle,
                    child: const Text("Change"),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: null,
                    style: buttonStyle,
                    child: const Text("Decorate"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WidescreenProfilePictureColumn extends StatelessWidget {
  const _WidescreenProfilePictureColumn({
    required this.image,
    required this.header,
    this.onChange,
    this.onRemove,
  });

  final ImageProvider? image;
  final Widget header;
  final VoidCallback? onChange;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Subheader(header, padding: EdgeInsets.zero),
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: BorderRadii.medium,
            border: Border.all(color: Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadii.medium,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: image == null
                  ? const SizedBox()
                  : Image(image: image, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: onChange,
              style:
                  FilledButton.styleFrom(visualDensity: VisualDensity.standard),
              child: const Text("Change"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRemove,
              style:
                  FilledButton.styleFrom(visualDensity: VisualDensity.standard),
              child: const Text("Remove"),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileFieldRow extends StatelessWidget {
  final TextEditingController? keyController;
  final TextEditingController? valueController;
  final VoidCallback? onRemove;
  final int? index;

  const _ProfileFieldRow({
    super.key,
    this.keyController,
    this.valueController,
    this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final index = this.index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    labelText: "Key",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: "Value",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              if (index == null)
                const SizedBox(width: 24 + 16 + 24 + 16)
              else ...[
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: onRemove,
                  tooltip: "Remove",
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.drag_indicator_rounded),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _DisplayNameField extends StatelessWidget {
  final TextEditingController? controller;

  const _DisplayNameField({
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Display name",
        helperText: "The name that appears on your profile",
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final TextEditingController? controller;

  const _DescriptionField({
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Description",
        border: OutlineInputBorder(),
      ),
      style: bodyMedium,
      maxLines: null,
    );
  }
}

class _ProfilePicturesHeader extends StatelessWidget {
  final ImageProvider? avatarImage;
  final ImageProvider? bannerImage;
  final VoidCallback? onChangePictures;

  const _ProfilePicturesHeader({
    this.avatarImage,
    this.bannerImage,
    this.onChangePictures,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatarImage = this.avatarImage;
    final bannerImage = this.bannerImage;
    final onChangePictures = this.onChangePictures;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: (96.0 + 8.0 * 2) / 2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadii.large,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 64 / 27,
                  child: bannerImage == null
                      ? const SizedBox()
                      : Image(image: bannerImage, fit: BoxFit.cover),
                ),
                if (onChangePictures != null)
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: _ChangePicturesButton(onPressed: onChangePictures),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surface,
                shape: theme.extension<AvatarTheme>()?.shape ??
                    const CircleBorder(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox.square(
                  dimension: 96.0,
                  child: avatarImage == null
                      ? null
                      : ClipOval(
                          child: Image(image: avatarImage, fit: BoxFit.cover),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
