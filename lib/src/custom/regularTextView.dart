import 'package:flutter/material.dart';

import '../../resrc/utils/routes/my_constant.dart';

class RegularTextView extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign textAlign;
  final int maxLine;

  const RegularTextView({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textSize = 14,
    this.underline=false,
    this.centerUnderline=false,
    this.textAlign=TextAlign.start,
    this.maxLine=1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text(text,textAlign: textAlign,maxLines: maxLine,softWrap: true,overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color,fontWeight: FontWeight.normal,fontFamily: MyConstant.currentFont
        ,fontSize: textSize,decoration: underline?TextDecoration.underline:centerUnderline?TextDecoration.lineThrough:TextDecoration.none));
  }

}

