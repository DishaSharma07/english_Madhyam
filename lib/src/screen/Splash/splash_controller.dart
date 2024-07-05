import 'dart:developer';
import 'package:get/get.dart';
import '../../auth/login/login_page.dart';
import '../../commonController/authenticationController.dart';
import '../bottom_nav/dashboard_page.dart';
class SplashController extends GetxController {
  AuthenticationManager? controller;

  @override
  void onInit() {
    log("splash has been mounted");
    nextScreen();
    super.onInit();
  }

  initialCall() async {
    controller = Get.find<AuthenticationManager>();
  }

  nextScreen() async {
    await initialCall();
    Future.delayed(const Duration(seconds: 3), () {
      if (controller!.isLogin()) {
        Get.offAndToNamed(DashboardPage.routeName);
      } else {
        Get.offAndToNamed(LoginPage.routeName);
      }
    });
  }
}
