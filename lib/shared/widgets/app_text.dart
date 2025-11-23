import 'package:flutter/material.dart';

///  textStyle : 'hb' → HubotSans , 'jb' → JetBrainsMono
class AppText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? w;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  final String textStyle;
  const AppText(
    this.data, {
    Key? key,
    this.style,
    this.fontSize,
    this.w,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textStyle = 'jb',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle effective =
        textStyle ==
            'hb' // HubotSans
        ? TextStyle(
            fontFamily: 'HubotSans',
            fontSize: fontSize ?? 16,
            fontWeight: w ?? FontWeight.w600,
            color: color,
            height: 1.3,
          )
        : TextStyle(
            // JetBrainsMono
            fontFamily: 'JetBrainsMono',
            fontSize: fontSize ?? 14,
            fontWeight: w ?? FontWeight.w400,
            color: color,
            height: 1.5,
          );

    effective = effective.merge(style ?? const TextStyle()); // caller overrides

    return Text(
      data,
      style: effective,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
