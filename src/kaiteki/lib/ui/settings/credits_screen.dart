import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/common.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:tuple/tuple.dart';

part 'credits_screen.g.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  late final Future<List<CreditsItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchCredits();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.creditsTitle)),
      body: FutureBuilder<List<CreditsItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: ErrorLandingWidget.fromAsyncSnapshot(snapshot),
            );
          } else if (!snapshot.hasData) {
            return centeredCircularProgressIndicator;
          } else {
            final items = snapshot.data!;
            return ListView.separated(
              itemBuilder: (_, i) => CreditsItemWidget(item: items[i]),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
            );
          }
        },
      ),
    );
  }

  Future<List<CreditsItem>> fetchCredits() async {
    final json = await rootBundle.loadString('assets/credits.json');
    return (jsonDecode(json) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(CreditsItem.fromJson)
        .toList(growable: false);
  }
}

class CreditsItemWidget extends StatelessWidget {
  const CreditsItemWidget({
    super.key,
    required this.item,
  });

  final CreditsItem item;

  @override
  Widget build(BuildContext context) {
    final roles = item.roles.map((e) {
      final split = e.split(":");
      final role = CreditsRole.values.firstWhere(
        (r) => r.name == split[0],
      );
      return Tuple2<CreditsRole, String?>(
        role,
        split.length >= 2 ? split[1] : null,
      );
    });
    return ListTile(
      title: Text(item.name),
      subtitle: IconTheme(
        data: IconThemeData(
          color: Theme.of(context).disabledColor,
          size: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var role in roles) buildRole(role.item1, role.item2),
          ],
        ),
      ),
      trailing: item.url.nullTransform(
        (website) => IconButton(
          icon: const Icon(Icons.open_in_new_rounded),
          onPressed: () => context.launchUrl(item.url!),
        ),
      ),
      isThreeLine: roles.length >= 2,
    );
  }

  Widget buildRole(CreditsRole role, String? details) {
    final Text text;
    final Icon icon;

    switch (role) {
      case CreditsRole.translator:
        final language = details!;
        icon = const Icon(Icons.translate_rounded);
        text = Text("Translator ($language)");
        break;

      case CreditsRole.contributor:
        icon = const Icon(Icons.code_rounded);
        text = const Text("Contributor");
        break;

      case CreditsRole.iconDesign:
        icon = const Icon(Icons.brush_rounded);
        text = const Text("Icon Design");
        break;

      case CreditsRole.qa:
        icon = const Icon(Icons.done_all_rounded);
        text = const Text("Contributor");
        break;

      case CreditsRole.reporter:
        icon = const Icon(Icons.bug_report_rounded);
        text = const Text("Issue Reporting");
        break;

      case CreditsRole.maintainer:
        icon = const Icon(Icons.favorite_rounded);
        text = const Text("Maintainer");
        break;

      default:
        throw UnimplementedError();
    }

    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        text,
      ],
    );
  }
}

enum CreditsRole {
  translator,
  iconDesign,
  maintainer,

  /// Someone who submitted bugs on GitHub
  reporter,

  /// Someone who submitted code pull requests
  contributor,

  /// Someone who tested the app for bugs/quality issues
  qa,
}

@JsonSerializable()
class CreditsItem {
  final String name;
  final String? url;
  final List<String> roles;

  CreditsItem({
    required this.name,
    this.url,
    this.roles = const [],
  });

  factory CreditsItem.fromJson(Map<String, dynamic> json) =>
      _$CreditsItemFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsItemToJson(this);
}
