import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/feed_model/feed_model.dart';
import 'package:english_madhyam/src/helper/providers/feed_providers/feed_prov..dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedController extends GetxController with GetSingleTickerProviderStateMixin{
  var loading = true.obs;
  Rx<FeedModel> feeds=FeedModel().obs;
  late AnimationController _feedAnimation;
  late Animation _animation;
  Animation get animation=>_animation;
  late PageController _pageController;
  PageController get pageController=>_pageController;

  @override
  void onInit() async {
    _feedAnimation=AnimationController(vsync: this,duration: const Duration(seconds: 8));
    _animation=Tween<double>(
      begin: 0,end: 1
    ).animate(_feedAnimation)
    ..addListener(() {update();});
    _pageController=PageController();
    _feedAnimation.forward();
    super.onInit();
  }



  //
  Future<void> feedApiFetch({required String type,required String date}) async {
    try {
      loading(true);
      var response = await FeedProvider().getFeed(type:type ,date: date);
      if (response != null) {
        feeds.value=response ;
update();
        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();

    } finally {
      loading(false);
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
