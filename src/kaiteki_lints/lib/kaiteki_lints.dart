import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'rules/l10n.dart';
import 'rules/prefer_media_query_aspects.dart';
import 'rules/prefer_widget_classes.dart';

PluginBase createPlugin() => _KaitekiLinter();

class _KaitekiLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      const LocalizationRule(),
      const PreferMediaQueryAspectsRule(),
    ];
  }
}
