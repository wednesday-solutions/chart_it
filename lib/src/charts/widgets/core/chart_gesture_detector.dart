import 'package:chart_it/src/interactions/hit_test/interaction_dispatcher.dart';
import 'package:flutter/material.dart';

class ChartGestureDetector extends StatelessWidget {
  final InteractionDispatcher interactionController;
  final Widget child;

  const ChartGestureDetector({
    super.key,
    required this.interactionController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        interactionController.onTapUp(details.localPosition);
      },
      onDoubleTapDown: (details) {
        interactionController.onDoubleTapDown(details.localPosition);
      },
      onDoubleTap: interactionController.onDoubleTap,
      onDoubleTapCancel: interactionController.onDoubleTapCancel,
      onPanStart: (details) {
        interactionController.onPanStart(details.localPosition);
      },
      onPanUpdate: (details) {
        interactionController.onPanUpdate(details.localPosition);
      },
      onPanCancel: interactionController.onPanCancel,
      onPanEnd: (details) {
        interactionController.onPanEnd();
      },
      child: child,
    );
  }
}
