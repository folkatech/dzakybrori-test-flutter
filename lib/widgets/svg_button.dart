import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../extensions/extension.dart';

// Custom icon button using svg file.
class SvgButton extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const SvgButton({
    Key? key,
    required this.path,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Stack required to move ripple effect material to the top of the layer.
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.all(context.dp(8)),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: borderRadius,
          ),
          child: SvgPicture.asset(path),
        ),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: InkWell(
                highlightColor: context.primaryColor.withOpacity(0.1),
                splashColor: context.primaryColor.withOpacity(0.2),
                onTap: onTap,
                borderRadius: borderRadius),
          ),
        ),
      ],
    );
  }
}
