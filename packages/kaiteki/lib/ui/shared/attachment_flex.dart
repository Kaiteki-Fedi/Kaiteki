import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

class AttachmentFlex extends MultiChildRenderObjectWidget {
  /// The maximum number of children to show in a row, before wrapping.
  final int mainAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  const AttachmentFlex({
    super.key,
    required super.children,
    this.mainAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  });

  @override
  RenderAttachmentFlex createRenderObject(BuildContext context) {
    return RenderAttachmentFlex(
      mainAxisCount: mainAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAttachmentFlex renderObject,
  ) {
    renderObject
      ..mainAxisCount = mainAxisCount
      ..mainAxisSpacing = mainAxisSpacing
      ..crossAxisSpacing = crossAxisSpacing;
  }
}

class AttachmentFlexParentData extends ContainerBoxParentData<RenderBox> {}

class RenderAttachmentFlex extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, AttachmentFlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, AttachmentFlexParentData>,
        DebugOverflowIndicatorMixin {
  RenderAttachmentFlex({
    List<RenderBox>? children,
    int mainAxisCount = 2,
    double mainAxisSpacing = 0,
    double crossAxisSpacing = 0,
  })  : _mainAxisCount = mainAxisCount,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing {
    addAll(children);
  }

  int _mainAxisCount;

  int get mainAxisCount => _mainAxisCount;

  set mainAxisCount(int value) {
    if (_mainAxisCount == value) return;
    _mainAxisCount = value;
    markNeedsLayout();
  }

  double _mainAxisSpacing;

  double get mainAxisSpacing => _mainAxisSpacing;

  set mainAxisSpacing(double value) {
    if (_mainAxisSpacing == value) return;
    _mainAxisSpacing = value;
    markNeedsLayout();
  }

  double _crossAxisSpacing;

  double get crossAxisSpacing => _crossAxisSpacing;

  set crossAxisSpacing(double value) {
    if (_crossAxisSpacing == value) return;
    _crossAxisSpacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! AttachmentFlexParentData) {
      child.parentData = AttachmentFlexParentData();
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    if (childCount == 1) {
      final child = firstChild!..layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
      return;
    }

    final fullRows = childCount ~/ _mainAxisCount;
    final crossAxisCount =
        fullRows + (childCount % _mainAxisCount == 0 ? 0 : 1);

    size = Size(
      constraints.maxWidth,
      constraints.maxHeight,
    );

    var rowHeight = size.height;
    rowHeight -= _crossAxisSpacing * (crossAxisCount - 1);
    rowHeight /= crossAxisCount;

    final children = getChildrenAsList();

    // layout full rows
    for (var i = 0; i < fullRows; i++) {
      final row = children.sublist(
        i * _mainAxisCount,
        (i + 1) * _mainAxisCount,
      );

      var cellWidth = constraints.maxWidth;
      cellWidth -= _mainAxisSpacing * (_mainAxisCount - 1);
      cellWidth /= _mainAxisCount;

      for (var j = 0; j < row.length; j++) {
        final child = row[j];
        final childSize = Size(cellWidth, rowHeight);
        final childConstraints = BoxConstraints.tight(childSize);

        child.layout(childConstraints);

        final childParentData = child.parentData as AttachmentFlexParentData;

        final childOffset = Offset(
          j * (cellWidth + _mainAxisSpacing),
          i * (rowHeight + _crossAxisSpacing),
        );
        childParentData.offset = childOffset;
      }
    }

    // layout left over row
    final leftOverCount = childCount % _mainAxisCount;
    for (var i = 0; i < leftOverCount; i++) {
      var cellWidth = constraints.maxWidth;
      cellWidth -= _mainAxisSpacing * (leftOverCount - 1);
      cellWidth /= leftOverCount;

      final index = fullRows * _mainAxisCount + i;
      final child = children[index];

      final childConstraints = BoxConstraints.tightFor(
        width: cellWidth,
        height: rowHeight,
      );

      child.layout(childConstraints);

      final offset = Offset(
        i * (cellWidth + _mainAxisSpacing),
        fullRows * (rowHeight + _crossAxisSpacing),
      );
      (child.parentData as AttachmentFlexParentData).offset = offset;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
