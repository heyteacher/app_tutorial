import 'package:app_tutorial/src/models/shape_models.dart';
import 'package:flutter/material.dart';

/// This is the class that will be used to create the shapes
class TutorialItem {

  /// This is the constructor of the class
  TutorialItem({
    required this.globalKey,
    required this.child,
    this.radius,
    this.color = const Color.fromRGBO(0, 0, 0, 0.6),
    this.borderRadius = const Radius.circular(10),
    this.shapeFocus = ShapeFocus.roundedSquare,
  });
  /// This is the key of the widget
  final GlobalKey globalKey;
  /// This is the shape of the widget
  final ShapeFocus shapeFocus;
  /// This is the widget that will be shown
  final Widget child;
  /// This is the radius of the widget
  final double? radius; // for oval shape
  /// This is the color of the widget
  final Color color;
  /// This is the border radius of the widget
  final Radius borderRadius;
}
