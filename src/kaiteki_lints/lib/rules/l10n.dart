import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
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

      final type = parent.constructorName.type.type;

      if (type == null) return;
      if (!_textWidgetChecker.isAssignableFromType(type)) return;

      var code = this.code;
      final stringValue = node.stringValue;

      if (stringValue == null) {
        code = LintCode(
          name: 'l10n',
          problemMessage:
              'Replace ${node.toSource()} with a reference to AppLocalizations',
        );
      } else {
        final materialKey = _tryGetMaterialKey(stringValue);

        if (materialKey == null) {
          code = LintCode(
            name: 'l10n',
            problemMessage:
                'Replace "$stringValue" with a reference to AppLocalizations',
          );
        } else {
          code = LintCode(
            name: 'l10n',
            problemMessage:
                'Replace "$stringValue" with MaterialLocalizations.$materialKey',
          );
        }
      }

      reporter.reportErrorForNode(code, node);
    });
  }

  @override
  List<Fix> getFixes() => [_ApplyMaterialLocalization()];
}

String? _tryGetMaterialKey(String translation) {
  final keys = [
    ("cancelButtonLabel", "Cancel"),
    ("closeButtonLabel", "Close"),
    ("continueButtonLabel", "Continue"),
    ("copyButtonLabel", "Copy"),
    ("cutButtonLabel", "Cut"),
    ("okButtonLabel", "OK"),
    ("pasteButtonLabel", "Paste"),
  ].where((e) => e.$2.toLowerCase() == translation.toLowerCase());

  if (keys.isEmpty) return null;

  return keys.first.$1;
}

class _ApplyMaterialLocalization extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addStringLiteral((node) {
      // final parent = node.parent;

      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final stringValue = node.stringValue;
      if (stringValue == null) return;

      final matchingKey = _tryGetMaterialKey(stringValue);
      if (matchingKey == null) return;

      // if (parent is! ArgumentList) return;

      // final argumentListParent = parent.parent;
      // if (argumentListParent is! InstanceCreationExpression) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use MaterialLocalizations',
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.sourceRange,
          'MaterialLocalizations.of(context).$matchingKey',
        );
      });
    });
  }
}
