import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: LoadingDialog(),
          );
        },
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: LoadingAnimationWidget.stretchedDots(
        color: Colors.white,
        size: 58,
      ),
    );
  }
}
