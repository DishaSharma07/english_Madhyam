import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:flutter/material.dart';
import 'boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  const AlreadyHaveAnAccountCheck(this.login, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RegularTextView(text:login ? "Don't have an account?" : "Already have an account?",color: Colors.black,),
        SizedBox(width: 6,),
        BoldTextView(text: login ? "Signup" : "Login",color: primaryColor,)
      ],
    );
  }
}
