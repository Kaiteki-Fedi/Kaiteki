import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'rules/l10n.dart';

PluginBase createPlugin() => _KaitekiLinter();

class _KaitekiLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      const LocalizationRule(),
    ];
  }
}
