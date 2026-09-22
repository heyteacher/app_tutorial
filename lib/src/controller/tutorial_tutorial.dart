import 'dart:async';

import 'package:app_tutorial_heyteacher/src/models/tutorial_item.dart';
import 'package:app_tutorial_heyteacher/src/painter/painter.dart';
import 'package:flutter/material.dart';

/// Tutorial class
class Tutorial {
  /// The overlay entryes
  static final List<OverlayEntry> entries = [];

  /// The count of items completed
  static late int count;

  /// Shows the tutorial
  static Future<void> showTutorial(
    BuildContext context,
    List<TutorialItem> children, {
    required VoidCallback onTutorialComplete,
  }) async {
    clearEntries();
    final size = MediaQuery.of(context).size;
    final overlayState = Overlay.of(context);

    count = 0;

    // Create a Completer to indicate when the tutorial is complete
    final tutorialCompleter = Completer<void>();
    for (final tutorialItem in children) {
      final offset = _capturePositionWidget(tutorialItem.globalKey);
      final sizeWidget = _getSizeWidget(tutorialItem.globalKey);
      entries.add(
        OverlayEntry(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                if (count < entries.length) {
                  entries[count].remove();
                  count++;
                  overlayState.insert(entries[count]);
                } else {
                  // If this is the last tutorial step, complete the tutorial
                  tutorialCompleter.complete();
                }
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    CustomPaint(
                      size: size,
                      painter: HolePainter(
                        shapeFocus: tutorialItem.shapeFocus,
                        dx: offset.dx + (sizeWidget.width / 2),
                        dy: offset.dy + (sizeWidget.height / 2),
                        width: sizeWidget.width,
                        height: sizeWidget.height,
                        color: tutorialItem.color,
                        borderRadius: tutorialItem.borderRadius,
                        radius: tutorialItem.radius,
                      ),
                    ),
                    tutorialItem.child,
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    if (entries.isNotEmpty) {
      overlayState.insert(entries[0]);
    }

    // Wait until the tutorialCompleter.future is completed to indicate the
    // tutorial is finished
    await tutorialCompleter.future;

    // If the onTutorialComplete function is provided, call it
    onTutorialComplete();
  }

  /// Clears the entries
  static void clearEntries() {
    entries.clear();
  }

  /// Skips the tutorial
  static void skipAll(BuildContext context) {
    if (count < entries.length) {
      entries[count].remove();
      count++;
    }
  }

  /// This method returns the position of the widget
  static Offset _capturePositionWidget(GlobalKey key) {
    final renderPosition = key.currentContext?.findRenderObject() as RenderBox?;

    return renderPosition?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  /// This method returns the size of the widget
  static Size _getSizeWidget(GlobalKey key) {
    final renderSize = key.currentContext?.findRenderObject() as RenderBox?;
    return renderSize?.size ?? Size.zero;
  }
}
