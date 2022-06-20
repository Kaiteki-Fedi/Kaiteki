import 'package:flutter/material.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';

class SubjectBar extends StatelessWidget {
  final String subject;
  final bool collapsed;
  final VoidCallback? onTap;

  const SubjectBar({
    Key? key,
    required this.subject,
    required this.collapsed,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPostPadding,
      child: Column(
        children: [
          ListTile(
            title: Text(
              subject,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            trailing: collapsed
                ? const Icon(Icons.expand_less_rounded)
                : const Icon(Icons.expand_more_rounded),
            contentPadding: EdgeInsets.zero,
            onTap: onTap,
          ),
          if (!collapsed)
            Column(
              children: const [
                Divider(height: 1),
                SizedBox(height: 8),
              ],
            ),
        ],
      ),
    );
  }
}
