import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _textWidgetChecker = TypeChecker.fromName('Text', packageName: 'flutter');

class LocalizationRule extends DartLintRule {
  const LocalizationRule() : super(code: _code);

  static const _code = LintCode(
    name: 'l10n',
    problemMessage: 'Replace string with a reference to AppLocalizations',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addStringLiteral((node) {
      AstNode? parent = node.parent;

      if (parent is! ArgumentList) return;
      parent = parent.parent;

      if (parent is! InstanceCreationExpression) return;

      final type = parent.constructorName.type?.type;

      if (type == null) return;
      if (!_textWidgetChecker.isAssignableFromType(type)) return;

      reporter.reportErrorForNode(
        LintCode(
          name: 'l10n',
          problemMessage:
              'Replace "${node.stringValue}" with a reference to AppLocalizations',
        ),
        node,
      );
    });
  }
}
