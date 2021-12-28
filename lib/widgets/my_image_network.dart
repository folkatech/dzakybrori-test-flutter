import 'package:flutter/material.dart';

import './shimmer_widget.dart';
import '../extensions/extension.dart';

// Custom image network to simplify loading and error handling.
class MyImageNetwork extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final double? height;

  const MyImageNetwork(this.imgUrl, {Key? key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return ShimmerWidget.rectangle(
            width: width ?? context.dw, height: height ?? context.dw);
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: context.disableColor.withOpacity(0.5),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: context.secondaryColor,
          size: context.dp(_getSize()),
        ),
      ),
    );
  }

  double _getSize() {
    if (width == null && height == null) {
      return 100;
    } else if (width! > height!) {
      return height! / 2;
    } else {
      return width! / 2;
    }
  }
}
