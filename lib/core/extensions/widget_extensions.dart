import 'package:flutter/widgets.dart';

/// Convenient extensions on [Widget].
extension WidgetX on Widget {
  /// Wraps the widget in a [Padding] with equal padding on all sides.
  Widget padAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  /// Wraps the widget in a [Padding] with horizontal padding.
  Widget padHorizontal(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );

  /// Wraps the widget in a [Padding] with vertical padding.
  Widget padVertical(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );

  /// Wraps the widget in a [Padding] with specific edge insets.
  Widget padOnly({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: l,
          top: t,
          right: r,
          bottom: b,
        ),
        child: this,
      );

  /// Centers the widget within its parent.
  Widget centered() => Center(child: this);

  /// Expands the widget to fill available space within a flex container.
  Widget expanded({int flex = 1}) => Expanded(
        flex: flex,
        child: this,
      );
}
