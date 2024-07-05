import 'package:english_madhyam/resrc/widgets/regularTextView.dart';



import 'package:flutter/material.dart';


import '../../src/utils/colors/colors.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';



class RoundedOutlineButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const RoundedOutlineButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = primaryColor,
    this.textColor = primaryColor,
    this.textSize=14,
    this.showIcon=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      height: 55,
      child: OutlinedButton(
          child: RegularTextView(text: text,color: textColor,textSize: textSize),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          onPressed: (){
            Future.delayed(Duration.zero, () async {
              press();
            });
          }
      ),
    );
  }
}

