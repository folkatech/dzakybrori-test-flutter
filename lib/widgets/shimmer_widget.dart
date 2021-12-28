import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../extensions/extension.dart';

// Custom shimmer widget to prevent redundant code when using shimmer effect.
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  // Basic constructor
  const ShimmerWidget(
      {Key? key,
      required this.width,
      required this.height,
      this.borderRadius,
      this.shape = BoxShape.rectangle})
      : super(key: key);

  // Shimmer Rectangle
  const ShimmerWidget.rectangle(
      {Key? key,
      required this.width,
      required this.height,
      this.borderRadius,
      this.shape = BoxShape.rectangle})
      : super(key: key);

  // Shimmer rounded corner
  const ShimmerWidget.rounded(
      {Key? key,
      required this.width,
      required this.height,
      required this.borderRadius,
      this.shape = BoxShape.rectangle})
      : super(key: key);

  // Shimmer circle
  const ShimmerWidget.circle(
      {Key? key,
      required this.width,
      required this.height,
      this.borderRadius,
      this.shape = BoxShape.circle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.disableColor.withOpacity(0.5),
      highlightColor: context.disableColor.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.disableColor.withOpacity(0.5),
          shape: shape,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
