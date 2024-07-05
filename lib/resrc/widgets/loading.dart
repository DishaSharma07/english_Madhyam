import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.7),
      // color: Colors.transparent,
      child: Center(
        child:  normalLoading(),
      ),
    );
  }

  Widget normalLoading(){
    return const CupertinoActivityIndicator(color: Colors.black,
        radius: 20.0);
  }
  Widget animatedLoading(){
    return  Lottie.asset('assets/animated/loading.json',height: 200);
  }

}

