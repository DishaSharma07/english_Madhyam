import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LoadMoreLoading extends StatelessWidget {
   const LoadMoreLoading({Key? key});

  @override
  Widget build(BuildContext context) {
    return normalLoading();
  }

  Widget normalLoading(){
    return const CupertinoActivityIndicator(color: Colors.black,
        radius: 20.0);
  }
  Widget animatedLoading(){
    return  Lottie.asset('assets/animated/loading.json',height: 80);
  }

}
