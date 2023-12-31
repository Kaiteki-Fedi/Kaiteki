import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _typeChecker =
    TypeChecker.fromName('MediaQueryData', packageName: 'flutter');

class PreferMediaQueryAspectsRule extends DartLintRule {
  const PreferMediaQueryAspectsRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_media_query_aspects',
    problemMessage:
        'Prefer calling MediaQuery method that depend on only one aspect',
  );

  static const mediaQueryAspects = {
    "size": "sizeOf",
    "orientation": "orientationOf",
    "devicePixelRatio": "devicePixelRatioOf",
    "textScaler": "textScalerOf",
    "textScaleFactor": "textScaleFactorOf",
    "platformBrightness": "platformBrightnessOf",
    "boldText": "boldTextOf",
    "highContrast": "highContrastOf",
    "disableAnimations": "disableAnimationsOf",
    "invertColors": "invertColorsOf",
    "alwaysUse24HourFormat": "alwaysUse24HourFormatOf",
    "accessibleNavigation": "accessibleNavigationOf",
    "navigationMode": "navigationModeOf",
    "displayFeatures": "displayFeaturesOf",
    "gestureSettings": "gestureSettingsOf",
    "viewPadding": "viewPaddingOf",
    "systemGestureInsets": "systemGestureInsetsOf",
    "viewInsets": "viewInsetsOf",
    "padding": "paddingOf",
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Detect access to e.g. MediaQuery.of(context).size and prompt to use MediaQuery.sizeOf(context) instead.
    context.registry.addPropertyAccess((node) {
      var propertyName = node.propertyName.name;
      final methodName = mediaQueryAspects[propertyName];
      if (methodName == null) return;

      final targetType = node.target?.staticType;
      if (targetType == null) return;
      if (!_typeChecker.isAssignableFromType(targetType)) return;

      reporter.reportErrorForNode(
        LintCode(
          name: 'prefer_media_query_aspects',
          problemMessage:
              'Prefer calling MediaQuery.$methodName(context) instead of MediaQuery.of(context).$propertyName',
          errorSeverity: ErrorSeverity.WARNING,
        ),
        node,
      );
    });
  }
}
