import 'package:flutter/material.dart';

// Build Custom Hero Widget to fixing some Hero Animation issue like Overlap Pixel and Text.
class HeroWidget extends StatelessWidget {
  final String tag;

  /// Choose between child and childFitted. If both have a value, child parameters will be picked.
  final Widget? child;
  final Widget? childFitted;

  const HeroWidget({Key? key, required this.tag, this.child, this.childFitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
        tag: tag,
        transitionOnUserGestures: true,
        child: Material(
            type: MaterialType.transparency,
            child: child ?? FittedBox(child: childFitted)),
      );
}
