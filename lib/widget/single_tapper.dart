import 'package:flutter/widgets.dart';

class SingleTapper extends StatefulWidget {
  const SingleTapper({
    super.key,
    required this.child,
    required this.onTap,
    this.time = const Duration(milliseconds: 500),
    this.tappable = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final Duration time;
  final bool tappable;

  @override
  State<SingleTapper> createState() => _SingleTapperState();
}

class _SingleTapperState extends State<SingleTapper> {
  int lastTappedTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.tappable) return;
        final now = DateTime.timestamp().millisecondsSinceEpoch;
        if (now - lastTappedTime < widget.time.inMilliseconds) {
          return;
        }
        lastTappedTime = now;
        widget.onTap();
      },
      child: widget.child,
    );
  }
}
