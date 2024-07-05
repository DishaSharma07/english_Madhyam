import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'package:english_madhyam/resrc/utils/app_colors.dart';


import '../../resrc/widgets/boldTextView.dart';
class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double height;
  final bool showIcon;
  final FontWeight weight;

  const RoundedButton(
      {Key? key,
        required this.text,
        required this.press,
        this.color = primaryColor,
        this.textColor = Colors.white,
        this.textSize = 20,
        this.showIcon = false,
        this.height = 55,
        this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      height: height,
      child: MaterialButton(
          animationDuration: const Duration(seconds: 1),
          color: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: BoldTextView(
            text: text,
            color: textColor,
            textSize: textSize,weight: FontWeight.w400,
            /*weight: weight,*/
          )),
    );
  }
}

