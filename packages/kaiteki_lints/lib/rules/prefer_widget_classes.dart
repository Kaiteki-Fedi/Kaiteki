import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _widgetChecker = TypeChecker.fromName('Widget', packageName: 'flutter');

class PreferWidgetClassesRule extends DartLintRule {
  const PreferWidgetClassesRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_widget_classes',
    problemMessage: 'Prefer widget classes over builder functions',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      var returnType = node.returnType?.type;
      if (returnType == null) return;
      if (!_widgetChecker.isAssignableFromType(returnType)) return;
      reporter.reportErrorForNode(_code, node);
    });
  }
}
