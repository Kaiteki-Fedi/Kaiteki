import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

part 'credits_screen.g.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({Key? key}) : super(key: key);

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
            return const Center(
              child: IconLandingWidget(
                icon: Icon(Icons.error),
                text: Text("Failed fetching credits"),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemBuilder: (_, i) => CreditsItemWidget(item: items[i]),
              itemCount: items.length,
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
    Key? key,
    required this.item,
  }) : super(key: key);

  final CreditsItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.roles.join(", ")),
      trailing: item.url.nullTransform(
        (website) => IconButton(
          icon: const Icon(Mdi.openInNew),
          onPressed: () => context.launchUrl(item.url!),
        ),
      ),
    );
  }
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
