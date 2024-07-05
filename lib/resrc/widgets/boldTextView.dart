import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoldTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final FontWeight weight;

  const BoldTextView(
      {Key? key,
      required this.text,
      this.color = Colors.black,
      this.textSize = 14,
      this.underline = false,
      this.centerUnderline = false,
      this.fontStyle = FontStyle.normal,
      this.textAlign = TextAlign.center,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 2,
        style: TextStyle(
            fontWeight: weight,
            fontStyle: fontStyle,
            fontFamily: 'Poppins',
            fontSize: textSize,
            color: color,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.overline
                    : TextDecoration.none));
  }
}
class BoldTextViewMultiple extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final FontWeight weight;

  const BoldTextViewMultiple(
      {Key? key,
        required this.text,
        this.color = Colors.black,
        this.textSize = 14,
        this.underline = false,
        this.centerUnderline = false,
        this.fontStyle = FontStyle.normal,
        this.textAlign = TextAlign.center,
        this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 2,
        style: TextStyle(
            fontWeight: weight,
            fontStyle: fontStyle,
            fontFamily: 'Poppins',
            fontSize: textSize,
            color: color,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                ? TextDecoration.overline
                : TextDecoration.none));
  }
}

