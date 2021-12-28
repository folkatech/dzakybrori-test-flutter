import 'package:flutter/material.dart';

import '../extensions/extension.dart';

// Custom text widget use to scaling text depends on screen size.
class MyText extends StatelessWidget {
  final String text;
  final int? maxLine;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final TextStyle? style;

  const MyText(
    this.text, {
    Key? key,
    this.style,
    this.maxLine,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      softWrap: true,
      maxLines: maxLine,
      overflow: overflow,
      textAlign: textAlign,
      textScaleFactor: context.ts,
    );
  }
}
