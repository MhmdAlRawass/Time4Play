import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color leftColor;
  final Color rightColor;
  final BorderRadius borderRadius;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderWidth = 4.0,
    required this.leftColor,
    required this.rightColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [leftColor, rightColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: borderRadius,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: borderRadius.subtract(
            BorderRadius.circular(borderWidth),
          ),
        ),
        child: child,
      ),
    );
  }
}
